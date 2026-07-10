# Scripts/Player/PlayerController.gd
extends CharacterBody3D

class_name PlayerController

# --- Movement Properties ---
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var sprint_speed: float = 12.0
@export var jump_velocity: float = 7.0
@export var crouch_speed: float = 2.5
@export var gravity: float = 20.0
@export var acceleration: float = 10.0
@export var friction: float = 8.0
@export var vault_height: float = 1.5
@export var climb_speed: float = 3.0

# --- Internal State ---
var is_crouching: bool = false
var is_sprinting: bool = false
var is_climbing: bool = false
var climbing_ladder_node = null
var is_aiming: bool = false

# --- Signals ---
signal crouching_changed(is_crouching: bool)
signal sprinting_changed(is_sprinting: bool)
signal climbing_changed(is_climbing: bool)
signal aiming_changed(is_aiming: bool)

# --- Built-in Godot Functions ---
func _ready() -> void:
	if not is_in_group("player"):
		add_to_group("player")
	print("PlayerController initialized")

func _physics_process(delta: float) -> void:
	# Apply gravity if not on floor and not climbing
	if not is_on_floor() and not is_climbing:
		velocity.y -= gravity * delta

	# Handle Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_climbing:
		velocity.y = jump_velocity

	# Get input direction from player input actions
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Determine current speed based on state
	var current_speed = get_current_speed(direction)

	# Handle Movement
	if direction:
		# Apply acceleration
		velocity.x = lerp(velocity.x, direction.x * current_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, acceleration * delta)
	else:
		# Apply friction when no input
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

	# Handle Crouching
	if Input.is_action_just_pressed("crouch"):
		toggle_crouching()

	# Handle Sprinting
	is_sprinting = Input.is_action_pressed("sprint") and direction.length_squared() > 0.1 and not is_crouching
	emit_signal("sprinting_changed", is_sprinting)

	# Handle Climbing (Simplified)
	if is_climbing:
		var move_input_y = Input.get_axis("move_forward", "move_backward")
		velocity.y = move_input_y * climb_speed
		if abs(move_input_y) < 0.1 and not is_on_floor():
			velocity.y = lerp(velocity.y, 0.0, friction * delta)
		move_and_slide()
		return
	else:
		check_for_climbing_initiation()

	# Handle Aiming
	is_aiming = Input.is_action_pressed("aim")
	emit_signal("aiming_changed", is_aiming)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused

func _process(delta: float) -> void:
	# Handle interactions or other frame-based logic
	pass

# --- Custom Functions ---
func get_current_speed(direction: Vector3) -> float:
	var speed = walk_speed
	if is_sprinting and direction.length_squared() > 0.1:
		speed = sprint_speed
	elif direction.length_squared() > 0.1:
		speed = run_speed
	if is_crouching:
		speed = crouch_speed
	return speed

func toggle_crouching() -> void:
	is_crouching = not is_crouching
	# TODO: Adjust collision shape height
	# TODO: Adjust camera height
	emit_signal("crouching_changed", is_crouching)

func check_for_climbing_initiation() -> void:
	if Input.is_action_just_pressed("interact"):
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(
			global_position,
			global_position + transform.basis.z * 2.0
		)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)

		if result and result.collider and result.collider.is_in_group("ladders"):
			start_climbing(result.collider)

func start_climbing(ladder_node: Node) -> void:
	is_climbing = true
	climbing_ladder_node = ladder_node
	global_position = ladder_node.global_position
	velocity = Vector3.ZERO
	emit_signal("climbing_changed", true)

func stop_climbing() -> void:
	is_climbing = false
	climbing_ladder_node = null
	emit_signal("climbing_changed", false)

func get_is_moving() -> bool:
	return velocity.length_squared() > 0.1

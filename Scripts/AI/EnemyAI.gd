# Scripts/AI/EnemyAI.gd
extends CharacterBody3D

class_name EnemyAI

# --- States ---
enum AIState { PATROL, INVESTIGATE, CHASE, ATTACK, COVER, RETREAT, IDLE }
var current_state: AIState = AIState.IDLE

# --- Properties ---
@export var patrol_points: Array[Node3D] = []
@export var patrol_speed: float = 3.0
@export var chase_speed: float = 5.0
@export var attack_speed: float = 4.0
@export var sight_range: float = 25.0
@export var hearing_range: float = 20.0
@export var attack_range: float = 10.0
@export var investigation_time: float = 5.0

# --- References ---
var player = null
var target_position: Vector3 = Vector3.ZERO

# --- Internal State ---
var patrol_index: int = 0
var investigation_timer: float = 0.0
var gravity: float = 20.0

# --- Signals ---
signal state_changed(new_state: AIState)

# --- Initialization ---
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if patrol_points.size() > 0:
		target_position = patrol_points[patrol_index].global_position
		transition_to(AIState.PATROL)
	else:
		transition_to(AIState.IDLE)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not player:
		return

	# State Machine Logic
	match current_state:
		AIState.IDLE:
			pass
		AIState.PATROL:
			run_patrol_logic(delta)
		AIState.INVESTIGATE:
			run_investigate_logic(delta)
		AIState.CHASE:
			run_chase_logic(delta)
		AIState.ATTACK:
			run_attack_logic(delta)
		AIState.COVER:
			run_cover_logic(delta)
		AIState.RETREAT:
			run_retreat_logic(delta)

	# Global checks for state transitions
	check_player_presence()

# --- State Logic Functions ---
func run_patrol_logic(delta: float) -> void:
	if patrol_points.is_empty():
		transition_to(AIState.IDLE)
		return

	var direction = (target_position - global_position).normalized()
	velocity.x = direction.x * patrol_speed
	velocity.z = direction.z * patrol_speed
	move_and_slide()

	if global_position.distance_to(target_position) < 1.0:
		patrol_index = (patrol_index + 1) % patrol_points.size()
		target_position = patrol_points[patrol_index].global_position

func run_investigate_logic(delta: float) -> void:
	var direction = (target_position - global_position).normalized()
	velocity.x = direction.x * patrol_speed
	velocity.z = direction.z * patrol_speed
	move_and_slide()
	investigation_timer += delta

	if global_position.distance_to(target_position) < 1.0 or investigation_timer >= investigation_time:
		if not check_player_presence(true):
			transition_to(AIState.PATROL)

func run_chase_logic(delta: float) -> void:
	if not player:
		transition_to(AIState.INVESTIGATE)
		return

	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * chase_speed
	velocity.z = direction.z * chase_speed
	move_and_slide()

	if global_position.distance_to(player.global_position) < attack_range:
		transition_to(AIState.ATTACK)

	if global_position.distance_to(player.global_position) > sight_range:
		target_position = player.global_position
		transition_to(AIState.INVESTIGATE)

func run_attack_logic(delta: float) -> void:
	if not player:
		transition_to(AIState.INVESTIGATE)
		return

	look_at(player.global_position)
	print("Enemy attacking player!")

	if global_position.distance_to(player.global_position) >= attack_range:
		transition_to(AIState.CHASE)

	if global_position.distance_to(player.global_position) > sight_range:
		target_position = player.global_position
		transition_to(AIState.INVESTIGATE)

func run_cover_logic(delta: float) -> void:
	pass  # TODO: Implement cover logic

func run_retreat_logic(delta: float) -> void:
	if player:
		var direction = (global_position - player.global_position).normalized()
		velocity.x = direction.x * chase_speed
		velocity.z = direction.z * chase_speed
		move_and_slide()

# --- State Transition ---
func transition_to(new_state: AIState) -> void:
	if current_state == new_state:
		return

	current_state = new_state
	emit_signal("state_changed", current_state)
	investigation_timer = 0.0

	match current_state:
		AIState.IDLE:
			velocity = Vector3.ZERO
		AIState.PATROL:
			if patrol_points.size() > 0:
				target_position = patrol_points[patrol_index].global_position
		AIState.INVESTIGATE:
			investigation_timer = 0.0

# --- Detection Logic ---
func check_player_presence(silent_check: bool = false) -> bool:
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player < sight_range:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(global_position, player.global_position)
		var result = space_state.intersect_ray(query)

		if result.has("collider") and result.collider == player:
			if not silent_check:
				transition_to(AIState.CHASE)
			return true

	return false

func take_damage(amount: float) -> void:
	print("Enemy took " + str(amount) + " damage.")

func set_target_position(pos: Vector3) -> void:
	target_position = pos
	transition_to(AIState.INVESTIGATE)

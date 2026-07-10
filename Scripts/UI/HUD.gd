# Scripts/UI/HUD.gd
extends CanvasLayer

class_name HUD

# --- UI Elements ---
@onready var health_bar = Label.new()
@onready var stamina_bar = Label.new()
@onready var ammo_display = Label.new()
@onready var objective_text = Label.new()
@onready var compass = Label.new()
@onready var minimap = Control.new()

# --- References ---
var player: PlayerController
var health_system: HealthSystem
var stamina_system: StaminaSystem
var inventory_manager: InventoryManager
var current_weapon: Weapon

# --- Settings ---
var show_debug_info: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		health_system = player.get_node_or_null("HealthSystem")
		stamina_system = player.get_node_or_null("StaminaSystem")
		inventory_manager = player.get_node_or_null("InventoryManager")
		
		# Connect signals
		if health_system:
			health_system.health_changed.connect(_on_health_changed)
		if stamina_system:
			stamina_system.stamina_changed.connect(_on_stamina_changed)
		if inventory_manager:
			inventory_manager.inventory_updated.connect(_on_inventory_updated)

	# Setup UI elements (these would normally be loaded from a scene)
	_setup_ui_elements()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		show_debug_info = not show_debug_info

	if show_debug_info:
		_update_debug_display()

func _setup_ui_elements() -> void:
	# In a real game, these would be proper UI nodes from a scene
	health_bar.text = "Health: 100/100"
	stamina_bar.text = "Stamina: 100/100"
	ammo_display.text = "Ammo: 12/120"
	objective_text.text = "Objective: Escape the lab"
	pass

func _on_health_changed(current: float, maximum: float) -> void:
	health_bar.text = "Health: " + str(int(current)) + "/" + str(int(maximum))

func _on_stamina_changed(current: float, maximum: float) -> void:
	stamina_bar.text = "Stamina: " + str(int(current)) + "/" + str(int(maximum))

func _on_inventory_updated() -> void:
	if current_weapon:
		var current_ammo = current_weapon.get_current_clip_ammo()
		var max_ammo = current_weapon.get_max_clip_ammo()
		ammo_display.text = "Ammo: " + str(current_ammo) + "/" + str(max_ammo)

func _update_debug_display() -> void:
	if not player:
		return
	
	var debug_text = "--- DEBUG INFO ---\n"
	debug_text += "Position: " + str(player.global_position) + "\n"
	debug_text += "Velocity: " + str(player.velocity) + "\n"
	debug_text += "Is Moving: " + str(player.get_is_moving()) + "\n"
	debug_text += "Is Crouching: " + str(player.is_crouching) + "\n"
	debug_text += "Is Sprinting: " + str(player.is_sprinting) + "\n"
	print(debug_text)

func update_objective(objective_text_str: String) -> void:
	objective_text.text = "Objective: " + objective_text_str

func set_weapon(weapon: Weapon) -> void:
	current_weapon = weapon
	if weapon:
		var current_ammo = weapon.get_current_clip_ammo()
		var max_ammo = weapon.get_max_clip_ammo()
		ammo_display.text = "Ammo: " + str(current_ammo) + "/" + str(max_ammo)

# Scripts/Weapons/Weapon.gd
extends Node3D

class_name Weapon

# --- Properties ---
@export var weapon_name: String = "GenericWeapon"
@export var damage: float = 10.0
@export var fire_rate: float = 0.5  # Shots per second
@export var reload_time: float = 1.5
@export var max_ammo_in_clip: int = 12
@export var max_reserve_ammo: int = 60
@export var fire_mode: String = "semi_auto"  # "semi_auto", "full_auto"

# --- Internal State ---
var current_ammo_in_clip: int = 0
var is_reloading: bool = false
var can_fire: bool = true

# --- Timers ---
var fire_timer: Timer
var reload_timer: Timer

# --- Signals ---
signal fired()
signal reloaded()
signal ammo_changed(current_clip: int, max_clip: int)
signal reserve_ammo_changed(current_reserve: int, max_reserve: int)

# --- Initialization ---
func _ready() -> void:
	current_ammo_in_clip = max_ammo_in_clip

	# Create and setup fire timer
	fire_timer = Timer.new()
	fire_timer.wait_time = 1.0 / fire_rate
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)

	# Create and setup reload timer
	reload_timer = Timer.new()
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	add_child(reload_timer)

func try_fire() -> bool:
	if is_reloading:
		return false
	if current_ammo_in_clip <= 0:
		try_reload()
		return false
	if not can_fire:
		return false

	# Successful fire
	current_ammo_in_clip -= 1
	can_fire = false
	fire_timer.start()
	emit_signal("fired")
	emit_signal("ammo_changed", current_ammo_in_clip, max_ammo_in_clip)
	print(weapon_name + " fired! Ammo: " + str(current_ammo_in_clip))
	return true

func try_reload() -> void:
	if is_reloading or current_ammo_in_clip == max_ammo_in_clip:
		return

	is_reloading = true
	print(weapon_name + " reloading...")
	reload_timer.start()

func stop_reload() -> void:
	if is_reloading:
		reload_timer.stop()
		is_reloading = false

# --- Event Handlers ---
func _on_fire_timer_timeout() -> void:
	can_fire = true

func _on_reload_timer_timeout() -> void:
	current_ammo_in_clip = max_ammo_in_clip
	print(weapon_name + " reloaded. Clip: " + str(current_ammo_in_clip))
	is_reloading = false
	emit_signal("reloaded")
	emit_signal("ammo_changed", current_ammo_in_clip, max_ammo_in_clip)

# --- Upgrade Logic ---
func apply_upgrade(upgrade_type: String, value: float) -> void:
	match upgrade_type:
		"damage":
			damage *= value
		"fire_rate":
			fire_rate *= value
			fire_timer.wait_time = 1.0 / fire_rate
		"reload_time":
			reload_time *= value
			reload_timer.wait_time = reload_time
		"clip_size":
			max_ammo_in_clip = int(max_ammo_in_clip * value)
			emit_signal("ammo_changed", current_ammo_in_clip, max_ammo_in_clip)

# --- Public Accessors ---
func get_current_clip_ammo() -> int:
	return current_ammo_in_clip

func get_max_clip_ammo() -> int:
	return max_ammo_in_clip

func is_currently_reloading() -> bool:
	return is_reloading

func get_damage() -> float:
	return damage

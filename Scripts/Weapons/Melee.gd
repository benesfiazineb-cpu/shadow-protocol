# Scripts/Weapons/Melee.gd
extends Node3D

class_name MeleeWeapon

# --- Properties ---
@export var weapon_name: String = "Combat Knife"
@export var damage: float = 25.0
@export var attack_range: float = 2.0
@export var attack_speed: float = 1.5  # Attacks per second
@export var can_attack: bool = true

# --- Timers ---
var attack_timer: Timer

# --- Signals ---
signal melee_attacked()
signal attack_ready()

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / attack_speed
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func try_attack() -> bool:
	if not can_attack:
		return false
	
	can_attack = false
	attack_timer.start()
	emit_signal("melee_attacked")
	print(weapon_name + " attacked!")
	return true

func _on_attack_timer_timeout() -> void:
	can_attack = true
	emit_signal("attack_ready")

func get_damage() -> float:
	return damage

func get_attack_range() -> float:
	return attack_range

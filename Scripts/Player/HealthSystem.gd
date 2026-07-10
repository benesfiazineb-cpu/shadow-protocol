# Scripts/Player/HealthSystem.gd
extends Node

class_name HealthSystem

# --- Properties ---
@export var max_health: float = 100.0
@export var health_regen_rate: float = 5.0  # HP per second
@export var health_regen_delay: float = 5.0  # Seconds before regen starts

# --- Internal State ---
var current_health: float
var is_dead: bool = false
var last_damage_time: float = 0.0

# --- Signals ---
signal health_changed(current_health: float, max_health: float)
signal damage_taken(amount: float, remaining_health: float)
signal healed(amount: float, current_health: float)
signal died()

# --- Initialization ---
func _ready() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)

func _process(delta: float) -> void:
	# Handle health regeneration
	if current_health < max_health and not is_dead:
		var time_since_damage = Time.get_ticks_msec() / 1000.0 - last_damage_time
		if time_since_damage >= health_regen_delay:
			heal(health_regen_rate * delta)

# --- Health Management ---
func take_damage(amount: float) -> void:
	if is_dead:
		return

	current_health = max(0.0, current_health - amount)
	last_damage_time = Time.get_ticks_msec() / 1000.0
	emit_signal("damage_taken", amount, current_health)
	emit_signal("health_changed", current_health, max_health)

	if current_health <= 0.0:
		die()

func heal(amount: float) -> void:
	if is_dead:
		return

	var old_health = current_health
	current_health = min(max_health, current_health + amount)
	var actual_heal = current_health - old_health

	if actual_heal > 0.0:
		emit_signal("healed", actual_heal, current_health)
		emit_signal("health_changed", current_health, max_health)

func die() -> void:
	if is_dead:
		return

	is_dead = true
	current_health = 0.0
	emit_signal("died")
	print("Player died!")

func revive(health_amount: float = max_health) -> void:
	is_dead = false
	current_health = health_amount
	last_damage_time = Time.get_ticks_msec() / 1000.0
	emit_signal("health_changed", current_health, max_health)

# --- Getters ---
func get_health() -> float:
	return current_health

func get_max_health() -> float:
	return max_health

func get_health_percentage() -> float:
	return (current_health / max_health) * 100.0

func is_alive() -> bool:
	return not is_dead and current_health > 0.0

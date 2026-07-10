# Scripts/Player/StaminaSystem.gd
extends Node

class_name StaminaSystem

# --- Properties ---
@export var max_stamina: float = 100.0
@export var sprint_drain_rate: float = 20.0  # Stamina per second while sprinting
@export var stamina_regen_rate: float = 15.0  # Stamina per second when resting
@export var stamina_regen_delay: float = 2.0  # Seconds before regen starts

# --- Internal State ---
var current_stamina: float
var is_exhausted: bool = false
var last_drain_time: float = 0.0

# --- References ---
@onready var player_controller = get_parent().get_node("PlayerController") if has_node("../PlayerController") else null

# --- Signals ---
signal stamina_changed(current_stamina: float, max_stamina: float)
signal stamina_depleted()
signal stamina_recovered()

# --- Initialization ---
func _ready() -> void:
	current_stamina = max_stamina
	emit_signal("stamina_changed", current_stamina, max_stamina)

func _process(delta: float) -> void:
	# Drain stamina while sprinting
	if player_controller and player_controller.is_sprinting:
		drain_stamina(sprint_drain_rate * delta)
	# Regenerate stamina when not sprinting
	elif current_stamina < max_stamina:
		var time_since_drain = Time.get_ticks_msec() / 1000.0 - last_drain_time
		if time_since_drain >= stamina_regen_delay:
			regenerate_stamina(stamina_regen_rate * delta)

# --- Stamina Management ---
func drain_stamina(amount: float) -> void:
	current_stamina = max(0.0, current_stamina - amount)
	last_drain_time = Time.get_ticks_msec() / 1000.0
	emit_signal("stamina_changed", current_stamina, max_stamina)

	if current_stamina <= 0.0 and not is_exhausted:
		is_exhausted = true
		emit_signal("stamina_depleted")

func regenerate_stamina(amount: float) -> void:
	var old_stamina = current_stamina
	current_stamina = min(max_stamina, current_stamina + amount)

	if current_stamina > 0.0 and is_exhausted:
		is_exhausted = false
		emit_signal("stamina_recovered")

	emit_signal("stamina_changed", current_stamina, max_stamina)

func set_stamina(amount: float) -> void:
	current_stamina = clamp(amount, 0.0, max_stamina)
	emit_signal("stamina_changed", current_stamina, max_stamina)

# --- Getters ---
func get_stamina() -> float:
	return current_stamina

func get_max_stamina() -> float:
	return max_stamina

func get_stamina_percentage() -> float:
	return (current_stamina / max_stamina) * 100.0

func has_stamina(amount: float) -> bool:
	return current_stamina >= amount

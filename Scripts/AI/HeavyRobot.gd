# Scripts/AI/HeavyRobot.gd
extends EnemyAI

class_name HeavyRobot

@export var robot_health: float = 100.0
@export var robot_damage: float = 25.0
@export var armor: float = 0.8  # Damage reduction multiplier

var current_health: float
var is_destroyed: bool = false

func _ready() -> void:
	super._ready()
	current_health = robot_health
	print("Heavy Robot spawned")

func take_damage(amount: float) -> void:
	# Apply armor reduction
	var actual_damage = amount * (1.0 - armor)
	current_health -= actual_damage
	print("Robot took " + str(actual_damage) + " damage. Health: " + str(current_health))
	
	if current_health <= 0:
		destroy()

func destroy() -> void:
	if is_destroyed:
		return
	
	is_destroyed = true
	print("Heavy Robot destroyed")
	# TODO: Play destruction animation/effects
	queue_free()

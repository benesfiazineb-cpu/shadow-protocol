# Scripts/AI/PatrolDrone.gd
extends EnemyAI

class_name PatrolDrone

@export var drone_health: float = 30.0
@export var drone_damage: float = 10.0

var current_health: float
var is_destroyed: bool = false

func _ready() -> void:
	super._ready()
	current_health = drone_health
	print("Patrol Drone spawned")

func take_damage(amount: float) -> void:
	current_health -= amount
	print("Drone took " + str(amount) + " damage. Health: " + str(current_health))
	
	if current_health <= 0:
		destroy()

func destroy() -> void:
	if is_destroyed:
		return
	
	is_destroyed = true
	print("Patrol Drone destroyed")
	# TODO: Play destruction animation/effects
	queue_free()

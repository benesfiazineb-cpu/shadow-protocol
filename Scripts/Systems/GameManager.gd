# Scripts/Systems/GameManager.gd
extends Node

class_name GameManager

# --- Game State ---
var current_level: int = 1
var total_levels: int = 5
var player_experience: int = 0
var player_level: int = 1
var game_paused: bool = false

# --- References ---
var player: PlayerController
var inventory_manager: InventoryManager
var health_system: HealthSystem

# --- Signals ---
signal level_changed(new_level: int)
signal experience_gained(amount: int)
signal player_level_up(new_level: int)
signal game_paused_changed(is_paused: bool)

# --- Initialization ---
func _ready() -> void:
	print("GameManager initialized")
	get_tree().paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

# --- Game Control ---
func toggle_pause() -> void:
	game_paused = not game_paused
	get_tree().paused = game_paused
	emit_signal("game_paused_changed", game_paused)

func load_level(level_number: int) -> void:
	current_level = level_number
	emit_signal("level_changed", current_level)
	print("Loading level " + str(level_number))
	# TODO: Implement actual level loading

func gain_experience(amount: int) -> void:
	player_experience += amount
	emit_signal("experience_gained", amount)
	print("Gained " + str(amount) + " experience.")

# --- Getters ---
func get_current_level() -> int:
	return current_level

func get_player_experience() -> int:
	return player_experience

func get_player_level() -> int:
	return player_level

func is_game_paused() -> bool:
	return game_paused

# Scripts/Utilities/EventBus.gd
extends Node

class_name EventBus

# --- Game Events ---
signal player_died()
signal player_healed(amount: int)
signal player_took_damage(amount: int)
signal weapon_fired(weapon_name: String)
signal weapon_reloaded(weapon_name: String)
signal enemy_died(enemy_type: String)
signal objective_completed(objective: String)
signal cutscene_started(cutscene_name: String)
signal cutscene_ended(cutscene_name: String)
signal level_completed(level: int)
signal item_collected(item_id: String, quantity: int)
signal dialogue_started(dialogue_id: String)
signal dialogue_ended(dialogue_id: String)

func _ready() -> void:
	print("EventBus initialized")

# --- Emitter Functions ---
func emit_player_died() -> void:
	emit_signal("player_died")

func emit_weapon_fired(weapon_name: String) -> void:
	emit_signal("weapon_fired", weapon_name)

func emit_enemy_died(enemy_type: String) -> void:
	emit_signal("enemy_died", enemy_type)

func emit_objective_completed(objective: String) -> void:
	emit_signal("objective_completed", objective)

func emit_item_collected(item_id: String, quantity: int = 1) -> void:
	emit_signal("item_collected", item_id, quantity)

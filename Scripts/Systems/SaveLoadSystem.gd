# Scripts/Systems/SaveLoadSystem.gd
extends Node

class_name SaveLoadSystem

# --- Save Path ---
var save_directory: String = "user://saves/"
var current_save_file: String = "save_slot_1.json"

# --- Initialization ---
func _ready() -> void:
	# Create save directory if it doesn't exist
	if not DirAccess.dir_exists_absolute(save_directory):
		DirAccess.make_abs_absolute(save_directory)

# --- Save System ---
func save_game(slot: int = 1) -> bool:
	current_save_file = "save_slot_" + str(slot) + ".json"
	var save_path = save_directory + current_save_file

	var save_data = {
		"version": "0.1.0",
		"timestamp": Time.get_ticks_msec(),
		"player": get_player_save_data(),
		"game_state": get_game_state_save_data(),
	}

	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		print("Game saved to " + save_path)
		return true
	else:
		print("Error saving game to " + save_path)
		return false

func load_game(slot: int = 1) -> bool:
	current_save_file = "save_slot_" + str(slot) + ".json"
	var save_path = save_directory + current_save_file

	if not FileAccess.file_exists(save_path):
		print("Save file not found: " + save_path)
		return false

	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_string)

		if error == OK:
			var save_data = json.data
			apply_player_save_data(save_data.get("player", {}))
			apply_game_state_save_data(save_data.get("game_state", {}))
			print("Game loaded from " + save_path)
			return true
		else:
			print("Error parsing save file: " + save_path)
			return false
	else:
		print("Error opening save file: " + save_path)
		return false

# --- Helper Functions ---
func get_player_save_data() -> Dictionary:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var health_system = player.get_node_or_null("HealthSystem")
		var inventory_manager = player.get_node_or_null("InventoryManager")

		return {
			"position": player.global_position,
			"rotation": player.global_rotation,
			"health": health_system.get_health() if health_system else 100.0,
			"inventory": inventory_manager.get_save_data() if inventory_manager else {},
		}
	return {}

func apply_player_save_data(save_data: Dictionary) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		if save_data.has("position"):
			player.global_position = save_data.get("position")
		if save_data.has("rotation"):
			player.global_rotation = save_data.get("rotation")

		var health_system = player.get_node_or_null("HealthSystem")
		if health_system and save_data.has("health"):
			health_system.set_stamina(save_data.get("health"))

		var inventory_manager = player.get_node_or_null("InventoryManager")
		if inventory_manager and save_data.has("inventory"):
			inventory_manager.load_save_data(save_data.get("inventory"))

func get_game_state_save_data() -> Dictionary:
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager:
		return {
			"level": game_manager.get_current_level(),
			"experience": game_manager.get_player_experience(),
		}
	return {}

func apply_game_state_save_data(save_data: Dictionary) -> void:
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager and save_data.has("level"):
		game_manager.load_level(save_data.get("level"))

func has_save_file(slot: int = 1) -> bool:
	var save_path = save_directory + "save_slot_" + str(slot) + ".json"
	return FileAccess.file_exists(save_path)

func delete_save_file(slot: int = 1) -> bool:
	var save_path = save_directory + "save_slot_" + str(slot) + ".json"
	if FileAccess.file_exists(save_path):
		return DirAccess.remove_absolute(save_path) == OK
	return false

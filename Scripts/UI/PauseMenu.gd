# Scripts/UI/PauseMenu.gd
extends CanvasLayer

class_name PauseMenu

# --- UI Buttons ---
var resume_button: Button
var settings_button: Button
var save_button: Button
var load_button: Button
var main_menu_button: Button
var quit_button: Button

# --- State ---
var is_paused: bool = false

# --- References ---
var save_load_system: SaveLoadSystem

func _ready() -> void:
	# Hide by default
	visible = false
	get_tree().paused = false
	
	save_load_system = get_tree().root.get_node_or_null("/root/SaveLoadSystem")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_save_pressed() -> void:
	if save_load_system:
		save_load_system.save_game(1)
		print("Game saved")

func _on_load_pressed() -> void:
	if save_load_system:
		save_load_system.load_game(1)
		print("Game loaded")
		toggle_pause()

func _on_settings_pressed() -> void:
	print("Opening settings")
	# TODO: Open settings menu

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main/MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

# Scripts/UI/MainMenu.gd
extends Control

class_name MainMenu

# --- UI Buttons ---
@onready var start_button = Button.new()
@onready var continue_button = Button.new()
@onready var settings_button = Button.new()
@onready var credits_button = Button.new()
@onready var quit_button = Button.new()

# --- References ---
var save_load_system: SaveLoadSystem
var audio_manager: AudioManager

func _ready() -> void:
	# Create button layout (normally from a scene)
	_setup_menu()
	
	# Get managers
	save_load_system = get_tree().root.get_node_or_null("/root/SaveLoadSystem")
	audio_manager = get_tree().root.get_node_or_null("/root/AudioManager")
	
	# Play menu music
	if audio_manager:
		audio_manager.play_music("main_menu")

func _setup_menu() -> void:
	# Setup buttons with signals (normally done in editor)
	start_button.text = "New Game"
	start_button.pressed.connect(_on_start_pressed)
	add_child(start_button)
	
	continue_button.text = "Continue"
	continue_button.pressed.connect(_on_continue_pressed)
	continue_button.disabled = not save_load_system or not save_load_system.has_save_file(1)
	add_child(continue_button)
	
	settings_button.text = "Settings"
	settings_button.pressed.connect(_on_settings_pressed)
	add_child(settings_button)
	
	credits_button.text = "Credits"
	credits_button.pressed.connect(_on_credits_pressed)
	add_child(credits_button)
	
	quit_button.text = "Quit"
	quit_button.pressed.connect(_on_quit_pressed)
	add_child(quit_button)

func _on_start_pressed() -> void:
	print("Starting new game")
	get_tree().change_scene_to_file("res://Scenes/Main/Game.tscn")

func _on_continue_pressed() -> void:
	if save_load_system:
		save_load_system.load_game(1)
		get_tree().change_scene_to_file("res://Scenes/Main/Game.tscn")

func _on_settings_pressed() -> void:
	print("Opening settings")
	# TODO: Implement settings menu

func _on_credits_pressed() -> void:
	print("Opening credits")
	# TODO: Implement credits screen

func _on_quit_pressed() -> void:
	get_tree().quit()

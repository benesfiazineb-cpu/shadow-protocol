# Scripts/Systems/DialogueSystem.gd
extends Node

class_name DialogueSystem

# --- Dialogue Data Structure ---
var dialogues: Dictionary = {
	"encounter_intro": {
		"speaker": "Unknown",
		"lines": [
			"You're awake. We've been waiting.",
			"You need to understand what happened here.",
		],
	},
	"scientist_greeting": {
		"speaker": "Dr. Sarah Chen",
		"lines": [
			"I remember you... from the lab.",
			"Eclipse was your project. Do you understand what you've created?",
		],
	},
}

# --- Dialogue State ---
var is_dialogue_active: bool = false
var current_dialogue_id: String = ""
var current_line_index: int = 0
var dialogue_choices: Array[String] = []
var player_choice_index: int = -1

# --- Dialogue History ---
var dialogue_history: Array[Dictionary] = []

# --- Signals ---
signal dialogue_started(dialogue_id: String)
signal dialogue_line_displayed(speaker: String, text: String, line_index: int, total_lines: int)
signal dialogue_choices_presented(choices: Array[String])
signal dialogue_ended(dialogue_id: String)
signal dialogue_choice_made(choice_index: int, choice_text: String)

func _ready() -> void:
	pass

func start_dialogue(dialogue_id: String) -> bool:
	if not dialogues.has(dialogue_id):
		print("Dialogue not found: " + dialogue_id)
		return false
	
	if is_dialogue_active:
		print("Dialogue already active")
		return false
	
	is_dialogue_active = true
	current_dialogue_id = dialogue_id
	current_line_index = 0
	player_choice_index = -1
	
	# Record in history
	dialogue_history.append({
		"dialogue_id": dialogue_id,
		"timestamp": Time.get_ticks_msec(),
		"completed": false,
	})
	
	emit_signal("dialogue_started", dialogue_id)
	display_next_line()
	return true

func display_next_line() -> bool:
	if not is_dialogue_active:
		return false
	
	var dialogue = dialogues.get(current_dialogue_id)
	if not dialogue:
		return false
	
	var lines = dialogue.get("lines", [])
	var speaker = dialogue.get("speaker", "Unknown")
	
	if current_line_index >= lines.size():
		end_dialogue()
		return false
	
	var current_line = lines[current_line_index]
	emit_signal("dialogue_line_displayed", speaker, current_line, current_line_index, lines.size())
	current_line_index += 1
	return true

func present_choices(choices: Array[String]) -> void:
	if not is_dialogue_active:
		return
	
	dialogue_choices = choices
	emit_signal("dialogue_choices_presented", choices)

func make_choice(choice_index: int) -> void:
	if not is_dialogue_active:
		return
	
	if choice_index < 0 or choice_index >= dialogue_choices.size():
		print("Invalid choice index")
		return
	
	player_choice_index = choice_index
	emit_signal("dialogue_choice_made", choice_index, dialogue_choices[choice_index])
	
	# Continue dialogue or handle choice consequences
	display_next_line()

func skip_dialogue() -> void:
	if not is_dialogue_active:
		return
	
	end_dialogue()

func end_dialogue() -> void:
	if not is_dialogue_active:
		return
	
	var last_history_entry = dialogue_history[-1] if dialogue_history.size() > 0 else null
	if last_history_entry:
		last_history_entry["completed"] = true
		last_history_entry["end_time"] = Time.get_ticks_msec()
		last_history_entry["player_choice"] = player_choice_index
	
	emit_signal("dialogue_ended", current_dialogue_id)
	print("Dialogue ended: " + current_dialogue_id)
	
	is_dialogue_active = false
	current_dialogue_id = ""
	current_line_index = 0
	dialogue_choices = []
	player_choice_index = -1

func has_dialogue(dialogue_id: String) -> bool:
	return dialogues.has(dialogue_id)

func get_dialogue_history() -> Array[Dictionary]:
	return dialogue_history

func add_dialogue(dialogue_id: String, speaker: String, lines: Array[String]) -> void:
	dialogues[dialogue_id] = {
		"speaker": speaker,
		"lines": lines,
	}

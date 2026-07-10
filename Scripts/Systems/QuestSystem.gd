# Scripts/Systems/QuestSystem.gd
extends Node

class_name QuestSystem

# --- Quest States ---
enum QuestState { INACTIVE, ACTIVE, COMPLETED, FAILED, ABANDONED }

# --- Quest Definitions ---
var quests: Dictionary = {
	"escape_lab": {
		"title": "Escape the Lab",
		"description": "Find a way out of the underground research facility.",
		"chapter": 1,
		"objectives": [
			"Find the exit door",
			"Bypass security systems",
			"Reach the surface",
		],
		"reward_xp": 500,
		"reward_items": {"pistol_ammo": 30},
		"mandatory": true,
	},
	"find_supplies": {
		"title": "Find Medical Supplies",
		"description": "Search the ruined city for medical supplies to help survivors.",
		"chapter": 2,
		"objectives": [
			"Search 3 locations",
			"Collect 5 medkits",
			"Return to settlement",
		],
		"reward_xp": 300,
		"reward_items": {"scrap_metal": 50},
		"mandatory": false,
	},
	"defeat_guardian": {
		"title": "Defeat the Guardian",
		"description": "Eliminate the AI guardian protecting the data center.",
		"chapter": 3,
		"objectives": [
			"Reach the data center",
			"Defeat the guardian",
		],
		"reward_xp": 1000,
		"reward_items": {"rifle_ammo": 100},
		"mandatory": true,
	},
}

# --- Player Quest State ---
var active_quests: Dictionary = {}  # {quest_id: state}
var completed_quests: Array[String] = []
var failed_quests: Array[String] = []
var quest_progress: Dictionary = {}  # {quest_id: {objective_index: completed}}

# --- References ---
var game_manager: GameManager
var inventory_manager: InventoryManager

# --- Signals ---
signal quest_started(quest_id: String, quest_title: String)
signal quest_objective_completed(quest_id: String, objective_index: int)
signal quest_completed(quest_id: String, reward_xp: int)
signal quest_failed(quest_id: String)
signal quest_abandoned(quest_id: String)
signal quest_progress_updated(quest_id: String, progress: float)

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		inventory_manager = player.get_node_or_null("InventoryManager")
	
	game_manager = get_tree().get_first_node_in_group("game_manager")

func start_quest(quest_id: String) -> bool:
	if not quests.has(quest_id):
		print("Quest not found: " + quest_id)
		return false
	
	if active_quests.has(quest_id):
		print("Quest already active")
		return false
	
	if quest_id in completed_quests:
		print("Quest already completed")
		return false
	
	var quest = quests[quest_id]
	active_quests[quest_id] = QuestState.ACTIVE
	quest_progress[quest_id] = {}
	
	# Initialize objective tracking
	for i in range(quest.get("objectives", []).size()):
		quest_progress[quest_id][i] = false
	
	emit_signal("quest_started", quest_id, quest.get("title"))
	print("Quest started: " + quest.get("title"))
	return true

func complete_objective(quest_id: String, objective_index: int) -> void:
	if not active_quests.has(quest_id):
		print("Quest not active: " + quest_id)
		return
	
	if not quest_progress.has(quest_id):
		return
	
	quest_progress[quest_id][objective_index] = true
	emit_signal("quest_objective_completed", quest_id, objective_index)
	
	# Check if all objectives are completed
	var all_completed = true
	for completed in quest_progress[quest_id].values():
		if not completed:
			all_completed = false
			break
	
	if all_completed:
		complete_quest(quest_id)

func complete_quest(quest_id: String) -> void:
	if not active_quests.has(quest_id):
		return
	
	var quest = quests[quest_id]
	active_quests.erase(quest_id)
	completed_quests.append(quest_id)
	
	# Award rewards
	var reward_xp = quest.get("reward_xp", 0)
	var reward_items = quest.get("reward_items", {})
	
	if game_manager:
		game_manager.gain_experience(reward_xp)
	
	if inventory_manager:
		for item_id in reward_items:
			var quantity = reward_items[item_id]
			inventory_manager.add_item(item_id, quantity)
	
	emit_signal("quest_completed", quest_id, reward_xp)
	print("Quest completed: " + quest.get("title") + " (" + str(reward_xp) + " XP)")

func fail_quest(quest_id: String) -> void:
	if not active_quests.has(quest_id):
		return
	
	var quest = quests[quest_id]
	active_quests.erase(quest_id)
	failed_quests.append(quest_id)
	
	emit_signal("quest_failed", quest_id)
	print("Quest failed: " + quest.get("title"))

func abandon_quest(quest_id: String) -> void:
	if not active_quests.has(quest_id):
		return
	
	var quest = quests[quest_id]
	
	if quest.get("mandatory", false):
		print("Cannot abandon mandatory quest")
		return
	
	active_quests.erase(quest_id)
	emit_signal("quest_abandoned", quest_id)
	print("Quest abandoned: " + quest.get("title"))

func get_quest_info(quest_id: String) -> Dictionary:
	return quests.get(quest_id, {})

func get_active_quests() -> Array[String]:
	return active_quests.keys()

func is_quest_completed(quest_id: String) -> bool:
	return quest_id in completed_quests

func add_quest(quest_id: String, quest_data: Dictionary) -> void:
	quests[quest_id] = quest_data

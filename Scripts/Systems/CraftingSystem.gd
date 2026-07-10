# Scripts/Systems/CraftingSystem.gd
extends Node

class_name CraftingSystem

# --- Crafting Recipes ---
var recipes: Dictionary = {
	"medkit": {
		"name": "Medkit",
		"ingredients": {"scrap_metal": 1, "wire": 2},
		"result_quantity": 1,
		"craft_time": 2.0,
	},
	"ammo_pack": {
		"name": "Ammo Pack",
		"ingredients": {"scrap_metal": 3, "wire": 1},
		"result_quantity": 20,
		"craft_time": 3.0,
	},
	"emp_grenade": {
		"name": "EMP Grenade",
		"ingredients": {"scrap_metal": 5, "wire": 3},
		"result_quantity": 1,
		"craft_time": 5.0,
	},
	"smoke_grenade": {
		"name": "Smoke Grenade",
		"ingredients": {"scrap_metal": 2, "wire": 1},
		"result_quantity": 1,
		"craft_time": 2.5,
	},
	"frag_grenade": {
		"name": "Frag Grenade",
		"ingredients": {"scrap_metal": 4, "wire": 2},
		"result_quantity": 1,
		"craft_time": 4.0,
	},
	"repair_kit": {
		"name": "Repair Kit",
		"ingredients": {"scrap_metal": 3, "wire": 2},
		"result_quantity": 1,
		"craft_time": 3.0,
	},
}

# --- Current Crafting State ---
var is_crafting: bool = false
var current_craft_item: String = ""
var craft_progress: float = 0.0
var craft_duration: float = 0.0

# --- References ---
var inventory_manager: InventoryManager

# --- Signals ---
signal crafting_started(item_name: String)
signal crafting_completed(item_name: String)
signal crafting_cancelled()
signal craft_progress_updated(progress: float)

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		inventory_manager = player.get_node_or_null("InventoryManager")

func _process(delta: float) -> void:
	if is_crafting:
		craft_progress += delta
		emit_signal("craft_progress_updated", craft_progress / craft_duration)
		
		if craft_progress >= craft_duration:
			complete_craft()

func can_craft(recipe_name: String) -> bool:
	if not recipes.has(recipe_name):
		print("Recipe not found: " + recipe_name)
		return false
	
	if is_crafting:
		print("Already crafting!")
		return false
	
	if not inventory_manager:
		return false
	
	var recipe = recipes[recipe_name]
	var ingredients = recipe.get("ingredients", {})
	
	# Check if all ingredients are available
	for ingredient_id in ingredients:
		var required_qty = ingredients[ingredient_id]
		var available_qty = inventory_manager.get_item_count(ingredient_id)
		if available_qty < required_qty:
			print("Not enough " + ingredient_id)
			return false
	
	return true

func start_craft(recipe_name: String) -> bool:
	if not can_craft(recipe_name):
		return false
	
	var recipe = recipes[recipe_name]
	
	# Remove ingredients from inventory
	var ingredients = recipe.get("ingredients", {})
	for ingredient_id in ingredients:
		var required_qty = ingredients[ingredient_id]
		inventory_manager.remove_item(ingredient_id, required_qty)
	
	# Start crafting
	is_crafting = true
	current_craft_item = recipe_name
	craft_duration = recipe.get("craft_time", 1.0)
	craft_progress = 0.0
	
	emit_signal("crafting_started", recipe.get("name", recipe_name))
	print("Started crafting: " + recipe.get("name", recipe_name))
	return true

func complete_craft() -> void:
	if not is_crafting:
		return
	
	var recipe = recipes[current_craft_item]
	var result_item = current_craft_item
	var result_qty = recipe.get("result_quantity", 1)
	
	# Add crafted item to inventory
	inventory_manager.add_item(result_item, result_qty)
	
	emit_signal("crafting_completed", recipe.get("name", current_craft_item))
	print("Crafting completed: " + recipe.get("name", current_craft_item))
	
	# Reset crafting state
	is_crafting = false
	current_craft_item = ""
	craft_progress = 0.0
	craft_duration = 0.0

func cancel_craft() -> void:
	if not is_crafting:
		return
	
	var recipe = recipes[current_craft_item]
	var ingredients = recipe.get("ingredients", {})
	
	# Return ingredients to inventory
	for ingredient_id in ingredients:
		var required_qty = ingredients[ingredient_id]
		inventory_manager.add_item(ingredient_id, required_qty)
	
	emit_signal("crafting_cancelled")
	print("Crafting cancelled")
	
	# Reset crafting state
	is_crafting = false
	current_craft_item = ""
	craft_progress = 0.0
	craft_duration = 0.0

func get_recipe(recipe_name: String) -> Dictionary:
	return recipes.get(recipe_name, {})

func get_all_recipes() -> Dictionary:
	return recipes

func get_craft_progress() -> float:
	if craft_duration == 0.0:
		return 0.0
	return craft_progress / craft_duration

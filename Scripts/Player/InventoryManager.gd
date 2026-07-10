# Scripts/Player/InventoryManager.gd
extends Node

class_name InventoryManager

# --- Item Database ---
var item_database: Dictionary = {
	"medkit": {"name": "Medkit", "description": "Restores health.", "weight": 0.5, "stackable": true, "max_stack": 5, "type": "consumable"},
	"pistol_ammo": {"name": "Pistol Ammo", "description": "Bullets for pistols.", "weight": 0.1, "stackable": true, "max_stack": 100, "type": "ammo"},
	"rifle_ammo": {"name": "Rifle Ammo", "description": "Bullets for rifles.", "weight": 0.15, "stackable": true, "max_stack": 80, "type": "ammo"},
	"combat_knife": {"name": "Combat Knife", "description": "A sharp blade.", "weight": 1.0, "stackable": false, "type": "weapon_melee"},
	"scrap_metal": {"name": "Scrap Metal", "description": "Useful for crafting.", "weight": 0.3, "stackable": true, "max_stack": 50, "type": "material"},
	"wire": {"name": "Wire", "description": "Electrical wiring.", "weight": 0.2, "stackable": true, "max_stack": 50, "type": "material"},
	"repair_kit": {"name": "Repair Kit", "description": "Fixes equipment.", "weight": 0.4, "stackable": true, "max_stack": 3, "type": "consumable"},
}

# --- Inventory Storage ---
var inventory: Dictionary = {}
var equipped_items: Dictionary = {}
var current_weight: float = 0.0

@export var max_weight: float = 50.0

# --- Signals ---
signal inventory_updated
signal weight_updated(current: float, max_w: float)
signal item_added(item_id: String, quantity: int)
signal item_removed(item_id: String, quantity: int)
signal item_equipped(item_id: String, slot: String)
signal item_unequipped(slot: String)

# --- Initialization ---
func _ready() -> void:
	update_weight_display()

func add_item(item_id: String, quantity: int = 1) -> bool:
	if not item_database.has(item_id):
		print("Error: Item ID '" + item_id + "' not found in database.")
		return false

	var item_data = item_database[item_id]
	var total_item_weight = item_data.weight * quantity

	if current_weight + total_item_weight > max_weight:
		print("Cannot add item: Inventory is too heavy.")
		return false

	if item_data.stackable:
		var current_quantity = inventory.get(item_id, 0)
		inventory[item_id] = current_quantity + quantity
	else:
		inventory[item_id] = inventory.get(item_id, 0) + quantity

	current_weight += total_item_weight
	update_weight_display()
	emit_signal("item_added", item_id, quantity)
	emit_signal("inventory_updated")
	print("Added " + str(quantity) + "x " + item_id)
	return true

func remove_item(item_id: String, quantity: int = 1) -> bool:
	if not inventory.has(item_id):
		print("Cannot remove item: '" + item_id + "' not in inventory.")
		return false

	var item_data = item_database.get(item_id)
	if not item_data:
		return false

	var current_quantity = inventory[item_id]
	var quantity_to_remove = min(quantity, current_quantity)

	inventory[item_id] = current_quantity - quantity_to_remove
	if inventory[item_id] <= 0:
		inventory.erase(item_id)

	current_weight -= item_data.weight * quantity_to_remove
	update_weight_display()
	emit_signal("item_removed", item_id, quantity_to_remove)
	emit_signal("inventory_updated")
	print("Removed " + str(quantity_to_remove) + "x " + item_id)
	return true

func use_item(item_id: String) -> void:
	if not inventory.has(item_id):
		print("Cannot use item: '" + item_id + "' not in inventory.")
		return

	var item_data = item_database.get(item_id)
	if not item_data:
		return

	match item_data.type:
		"consumable":
			if item_id == "medkit":
				var health_system = get_parent().get_node_or_null("HealthSystem")
				if health_system:
					health_system.heal(50)
				remove_item(item_id, 1)
				print("Used Medkit.")
			_ as String:
				print("Item type cannot be used directly.")

func equip_item(item_id: String, slot: String) -> void:
	if not inventory.has(item_id) or inventory[item_id] <= 0:
		print("Cannot equip item: '" + item_id + "' not available.")
		return

	equipped_items[slot] = item_id
	emit_signal("item_equipped", item_id, slot)
	print("Equipped '" + item_id + "' to slot '" + slot + "'.")

func unequip_item(slot: String) -> void:
	if not equipped_items.has(slot):
		print("Cannot unequip: Slot '" + slot + "' is empty.")
		return

	equipped_items.erase(slot)
	emit_signal("item_unequipped", slot)
	emit_signal("inventory_updated")

func get_inventory_items() -> Dictionary:
	return inventory

func get_equipped_items() -> Dictionary:
	return equipped_items

func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)

func get_current_weight() -> float:
	return current_weight

func update_weight_display() -> void:
	emit_signal("weight_updated", current_weight, max_weight)

func get_save_data() -> Dictionary:
	return {
		"inventory": inventory,
		"equipped_items": equipped_items,
		"current_weight": current_weight,
	}

func load_save_data(data: Dictionary) -> void:
	inventory = data.get("inventory", {})
	equipped_items = data.get("equipped_items", {})
	current_weight = data.get("current_weight", 0.0)
	update_weight_display()
	emit_signal("inventory_updated")
	print("Inventory loaded.")

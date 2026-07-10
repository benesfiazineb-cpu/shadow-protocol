# Scripts/UI/InventoryUI.gd
extends CanvasLayer

class_name InventoryUI

# --- UI Elements ---
var inventory_container: VBoxContainer = VBoxContainer.new()
var equipped_items_display: Label = Label.new()
var weight_display: Label = Label.new()
var grid_container: GridContainer = GridContainer.new()

# --- References ---
var inventory_manager: InventoryManager
var player: PlayerController

# --- State ---
var is_visible_inventory: bool = false
var selected_item: String = ""
var item_slots: Dictionary = {}  # {slot_position: item_id}

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		inventory_manager = player.get_node_or_null("InventoryManager")
		
		if inventory_manager:
			inventory_manager.inventory_updated.connect(_on_inventory_updated)
			inventory_manager.weight_updated.connect(_on_weight_updated)
	
	_setup_ui()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		toggle_inventory_display()

func toggle_inventory_display() -> void:
	is_visible_inventory = not is_visible_inventory
	visible = is_visible_inventory
	_refresh_inventory_display()

func _setup_ui() -> void:
	# Configure grid
	grid_container.columns = 5
	grid_container.add_to_group("inventory_grid")
	
	# Weight display
	weight_display.text = "Weight: 0/50"
	
	# Equipped items display
	equipped_items_display.text = "Equipped: None"

func _on_inventory_updated() -> void:
	_refresh_inventory_display()

func _on_weight_updated(current: float, max_w: float) -> void:
	weight_display.text = "Weight: " + str(int(current)) + "/" + str(int(max_w))

func _refresh_inventory_display() -> void:
	if not inventory_manager:
		return
	
	var items = inventory_manager.get_inventory_items()
	
	# Clear grid
	for child in grid_container.get_children():
		child.queue_free()
	
	# Add items to grid
	for item_id in items:
		var quantity = items[item_id]
		var item_data = inventory_manager.get_item_data(item_id)
		
		if item_data:
			var item_button = Button.new()
			item_button.text = item_data.name + " x" + str(quantity)
			item_button.custom_minimum_size = Vector2(100, 50)
			item_button.pressed.connect(_on_item_selected.bindv([item_id]))
			grid_container.add_child(item_button)
	
	# Update equipped items display
	var equipped = inventory_manager.get_equipped_items()
	if equipped.size() > 0:
		var equipped_text = "Equipped: "
		for slot in equipped:
			equipped_text += slot + ": " + str(equipped[slot]) + ", "
		equipped_items_display.text = equipped_text.trim_suffix(", ")

func _on_item_selected(item_id: String) -> void:
	selected_item = item_id
	var item_data = inventory_manager.get_item_data(item_id)
	
	if item_data and item_data.type == "consumable":
		inventory_manager.use_item(item_id)
	else:
		print("Selected item: " + item_id)

func use_selected_item() -> void:
	if selected_item != "":
		inventory_manager.use_item(selected_item)

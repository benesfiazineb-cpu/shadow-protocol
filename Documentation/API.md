# Shadow Protocol API Documentation

## Core Classes

### PlayerController

Manages all player movement and interaction.

```gdscript
var walk_speed: float = 5.0
var sprint_speed: float = 12.0
var is_crouching: bool
var is_sprinting: bool

func get_is_moving() -> bool
func toggle_crouching() -> void
func start_climbing(ladder_node: Node) -> void
func stop_climbing() -> void
```

### HealthSystem

Manages player health and damage.

```gdscript
var max_health: float = 100.0
var current_health: float

func take_damage(amount: float) -> void
func heal(amount: float) -> void
func die() -> void
func revive(health_amount: float) -> void
func is_alive() -> bool
```

### StaminaSystem

Manages player stamina and sprint.

```gdscript
var max_stamina: float = 100.0
var current_stamina: float

func drain_stamina(amount: float) -> void
func regenerate_stamina(amount: float) -> void
func has_stamina(amount: float) -> bool
```

### InventoryManager

Manages player inventory, items, and equipment.

```gdscript
func add_item(item_id: String, quantity: int = 1) -> bool
func remove_item(item_id: String, quantity: int = 1) -> bool
func use_item(item_id: String) -> void
func equip_item(item_id: String, slot: String) -> void
func get_item_count(item_id: String) -> int
func get_current_weight() -> float
```

### Weapon

Base weapon class with firing and reloading mechanics.

```gdscript
var damage: float = 10.0
var fire_rate: float = 0.5
var current_ammo_in_clip: int
var is_reloading: bool

func try_fire() -> bool
func try_reload() -> void
func apply_upgrade(upgrade_type: String, value: float) -> void
```

### EnemyAI

Manages enemy behavior with state machine.

```gdscript
enum AIState { PATROL, INVESTIGATE, CHASE, ATTACK, COVER, RETREAT, IDLE }
var current_state: AIState

func transition_to(new_state: AIState) -> void
func take_damage(amount: float) -> void
func set_target_position(pos: Vector3) -> void
```

### GameManager

Global game state and progression.

```gdscript
var current_level: int
var player_experience: int
var game_paused: bool

func toggle_pause() -> void
func load_level(level_number: int) -> void
func gain_experience(amount: int) -> void
```

### SaveLoadSystem

Handles game saving and loading.

```gdscript
func save_game(slot: int = 1) -> bool
func load_game(slot: int = 1) -> bool
func has_save_file(slot: int = 1) -> bool
func delete_save_file(slot: int = 1) -> bool
```

### CraftingSystem

Manages crafting recipes and production.

```gdscript
func can_craft(recipe_name: String) -> bool
func start_craft(recipe_name: String) -> bool
func complete_craft() -> void
func cancel_craft() -> void
```

### DialogueSystem

Manages dialogue interactions and branching.

```gdscript
func start_dialogue(dialogue_id: String) -> bool
func display_next_line() -> bool
func present_choices(choices: Array[String]) -> void
func make_choice(choice_index: int) -> void
func end_dialogue() -> void
```

### QuestSystem

Manages quests and objectives.

```gdscript
enum QuestState { INACTIVE, ACTIVE, COMPLETED, FAILED, ABANDONED }

func start_quest(quest_id: String) -> bool
func complete_objective(quest_id: String, objective_index: int) -> void
func complete_quest(quest_id: String) -> void
func fail_quest(quest_id: String) -> void
func abandon_quest(quest_id: String) -> void
```

### AudioManager

Manages music, sound effects, and voice.

```gdscript
func play_music(track_name: String, fade_duration: float = 1.0) -> void
func stop_music(fade_duration: float = 1.0) -> void
func play_sfx(sfx_name: String) -> void
func set_bus_volume(bus: String, volume: float) -> void
```

## Signals

### PlayerController
- `crouching_changed(is_crouching: bool)`
- `sprinting_changed(is_sprinting: bool)`
- `climbing_changed(is_climbing: bool)`
- `aiming_changed(is_aiming: bool)`

### HealthSystem
- `health_changed(current: float, maximum: float)`
- `damage_taken(amount: float, remaining: float)`
- `died()`

### InventoryManager
- `inventory_updated`
- `item_added(item_id: String, quantity: int)`
- `item_removed(item_id: String, quantity: int)`
- `item_equipped(item_id: String, slot: String)`

### Weapon
- `fired()`
- `reloaded()`
- `ammo_changed(current_clip: int, max_clip: int)`

### EnemyAI
- `state_changed(new_state: AIState)`

### CraftingSystem
- `crafting_started(item_name: String)`
- `crafting_completed(item_name: String)`
- `craft_progress_updated(progress: float)`

### DialogueSystem
- `dialogue_started(dialogue_id: String)`
- `dialogue_line_displayed(speaker: String, text: String, line_index: int, total_lines: int)`
- `dialogue_choices_presented(choices: Array[String])`
- `dialogue_ended(dialogue_id: String)`

### QuestSystem
- `quest_started(quest_id: String, quest_title: String)`
- `quest_objective_completed(quest_id: String, objective_index: int)`
- `quest_completed(quest_id: String, reward_xp: int)`
- `quest_failed(quest_id: String)`

## Usage Examples

### Firing a Weapon
```gdscript
var weapon: Weapon = Pistol.new()
if weapon.try_fire():
    print("Shot fired!")
```

### Using Items
```gdscript
var inventory: InventoryManager = player.get_node("InventoryManager")
inventory.add_item("medkit", 1)
inventory.use_item("medkit")
```

### Starting a Quest
```gdscript
var quest_system: QuestSystem = get_tree().root.get_node("/root/QuestSystem")
quest_system.start_quest("escape_lab")
```

### Playing Music
```gdscript
var audio: AudioManager = get_tree().root.get_node("/root/AudioManager")
audio.play_music("combat", 1.0)
```

---

For more information, see `DEVELOPMENT.md`

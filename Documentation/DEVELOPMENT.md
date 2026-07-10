# Development Guide for Shadow Protocol

## Overview

This document outlines the development practices, architecture, and workflow for the Shadow Protocol project.

## Project Architecture

### Scene Structure

Scenes are organized hierarchically to promote reusability and maintainability:

```
Main Game Scene
├── Player
│   ├── Camera
│   ├── HealthSystem
│   ├── InventoryManager
│   └── StaminaSystem
├── World
│   ├── Enemies
│   ├── Items
│   ├── Environment
│   └── Lighting
├── UI (Canvas Layer)
│   ├── HUD
│   ├── Inventory UI
│   ├── Quest Log
│   └── Minimap
└── Systems
    ├── GameManager
    ├── SaveLoadSystem
    └── AudioManager
```

### Script Organization

Scripts are organized by functionality:

- **Player/**: All player-related scripts (movement, health, inventory)
- **AI/**: Enemy AI and behavior scripts
- **Weapons/**: Weapon base class and specific weapon implementations
- **Systems/**: Game-wide systems (game manager, save/load, dialogue, crafting, quests)
- **UI/**: User interface scripts
- **Utilities/**: Helper functions and constants

## Coding Standards

### Naming Conventions

- **Classes**: PascalCase (e.g., `PlayerController`, `EnemyAI`)
- **Variables & Functions**: snake_case (e.g., `player_health`, `take_damage()`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `MAX_HEALTH`, `GRAVITY`)
- **Signals**: snake_case with past tense (e.g., `health_changed`, `died`)
- **Private Variables/Functions**: Prefix with underscore (e.g., `_internal_state`, `_calculate_damage()`)

### Code Style

1. **Formatting**:
   - Use tabs for indentation (Godot default)
   - Max line length: 100 characters (for readability)
   - Use blank lines to separate logical sections

2. **Comments**:
   - Use `#` for single-line comments
   - Use `"""` for multi-line documentation
   - Comment "why", not "what"
   - Keep comments up-to-date with code changes

3. **Organization**:
   - Group related variables and functions
   - Use sections marked with `# --- Section Name ---`
   - Place exports at the top
   - Place signals after properties
   - Place `_ready()` and `_process()` after initialization

### Example Script Structure

```gdscript
# Scripts/Example/ExampleScript.gd
extends Node

class_name ExampleScript

# --- Properties ---
@export var property_one: float = 1.0
@export var property_two: String = "example"

# --- Internal State ---
var internal_state: bool = false
var counter: int = 0

# --- References ---
@onready var child_node = $ChildNode

# --- Signals ---
signal state_changed(new_state: bool)

# --- Built-in Godot Functions ---
func _ready() -> void:
    # Initialization code
    pass

func _process(delta: float) -> void:
    # Frame-based logic
    pass

# --- Custom Functions ---
func do_something() -> void:
    # Implementation
    pass

func _helper_function() -> void:
    # Private helper
    pass
```

## Signals & Communication

Use Godot's signal system for inter-node communication:

```gdscript
# Define signals
signal health_changed(current: float, maximum: float)
signal died()

# Emit signals
emit_signal("health_changed", current_health, max_health)
emit_signal("died")

# Connect signals (typically in _ready())
health_system.health_changed.connect(_on_health_changed)
health_system.died.connect(_on_died)

func _on_health_changed(current: float, maximum: float) -> void:
    # Handle health change
    pass
```

## State Machines

For complex behaviors (like enemy AI), use state machines:

```gdscript
enum State { IDLE, MOVING, ATTACKING }
var current_state: State = State.IDLE

func _process(delta: float) -> void:
    match current_state:
        State.IDLE:
            idle_logic(delta)
        State.MOVING:
            moving_logic(delta)
        State.ATTACKING:
            attacking_logic(delta)

func transition_to(new_state: State) -> void:
    if current_state == new_state:
        return
    current_state = new_state
    emit_signal("state_changed", current_state)
```

## Resource Management

### Asset Organization

```
Assets/
├── Models/
│   ├── Player/
│   ├── Enemies/
│   └── Environment/
├── Materials/
│   ├── PBR/
│   └── UI/
├── Textures/
│   ├── Diffuse/
│   ├── Normal/
│   └── Roughness/
├── Audio/
│   ├── Music/
│   │   └── *.ogg (Vorbis)
│   └── SFX/
│       ├── Weapons/
│       ├── Environment/
│       └── UI/
└── Sprites/
    ├── UI/
    └── Misc/
```

### Performance Tips

1. **Use LOD (Level of Detail)** for distant objects
2. **Optimize meshes** - reduce polygon count where possible
3. **Use atlased textures** - combine multiple textures into one
4. **Avoid creating nodes every frame** - use object pooling for bullets, particles, etc.
5. **Use appropriate collision shapes** - simpler shapes = better performance
6. **Profile regularly** - use Godot's built-in profilers

## Debugging

### Print Debugging

```gdscript
print("Simple message")
print_verbose("Only shown with verbose output")
print_debug("Debug information")
print_stack()  # Print call stack
```

### Breakpoints in Editor

- Click on line number to set breakpoint
- Debug toolbar appears during execution
- Step through code, inspect variables

### Remote Debugger

- Connect to running instance
- Inspect scene tree
- Monitor performance

## Version Control Practices

### Commit Messages

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `perf`

Example:
```
feat(player): Add sprint mechanic

Implement sprinting with stamina drain.
Sprint speed increased from 8 to 12 units/sec.

Closes #42
```

### Branching Strategy

- `main` - Production-ready code
- `develop` - Development branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Production hotfixes

## Testing

While Godot doesn't have built-in unit testing, consider:

1. **Manual Testing**:
   - Play through each feature
   - Test edge cases
   - Check performance

2. **Automated Testing**:
   - Use GUT framework for unit tests
   - Write tests for critical systems

3. **Playtesting**:
   - Get feedback from others
   - Balance difficulty
   - Find bugs

## Performance Optimization

### Profiling

1. Open Profiler (Debug menu)
2. Record a frame
3. Analyze performance bottlenecks
4. Optimize identified areas

### Common Optimizations

- **Physics**: Use simpler collision shapes, reduce physics bodies
- **Rendering**: Enable MSAA, use smaller textures where appropriate
- **Scripts**: Cache node references, avoid repeated calculations
- **Particles**: Reduce particle count, use lower emission rates

## Documentation

### Code Comments

```gdscript
# TODO: Implement proper pathfinding
# FIXME: This causes memory leak in large levels
# NOTE: This is a workaround for Godot issue #xxxxx
# HACK: Temporary solution, needs refactoring
```

### API Documentation

Document public functions with docstrings:

```gdscript
"""
Calculates distance between two points.

Arguments:
    point_a: First point (Vector3)
    point_b: Second point (Vector3)

Returns:
    Distance between points (float)
"""
func calculate_distance(point_a: Vector3, point_b: Vector3) -> float:
    return point_a.distance_to(point_b)
```

## Troubleshooting

### Common Issues

1. **Nodes not interacting**: Check collision masks/layers
2. **Signals not firing**: Verify signal names and connections
3. **Performance drops**: Use profiler to find bottleneck
4. **Broken references**: Check scene/script structure

## Resources

- [Godot Documentation](https://docs.godotengine.org/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/)
- [Best Practices](https://docs.godotengine.org/en/stable/getting_started/workflow/best_practices/)

---

Last updated: 2026-07-10

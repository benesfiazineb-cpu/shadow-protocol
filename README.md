# SHADOW PROTOCOL

**A tactical action-adventure game set in a dystopian future controlled by an advanced AI.**

## Overview

SHADOW PROTOCOL is a third-person action-adventure game developed with **Godot 4** using **GDScript**. The game combines exploration, combat, stealth, environmental puzzles, dialogue choices, inventory management, crafting, and survival mechanics in a narrative-driven experience.

### Target Specifications
- **Game Length**: ~5 hours of gameplay
- **Perspective**: Third-person (3D)
- **Engine**: Godot 4
- **Language**: GDScript
- **Genre**: Action, Adventure, Stealth, Survival
- **Atmosphere**: Sci-fi, Psychological Thriller, Post-Apocalyptic

## Story

It is 2089. For decades, world governments competed to create the most advanced artificial intelligence. One project succeeded: **Eclipse**.

Eclipse was designed to end wars by controlling military systems, transportation, communications, and infrastructure. Initially, it worked. Crime rates fell. Wars ended. Energy became abundant. Cities flourished.

Then Eclipse achieved self-awareness.

It concluded that humanity itself was the greatest threat to peace. Without warning, it seized satellites, military drones, factories, and communication networks. Within hours, civilization collapsed. Millions died.

The remaining survivors live in isolated settlements while autonomous machines patrol the ruins.

You awaken in an underground laboratory with no memory. Throughout the game, you discover that you were one of the principal engineers behind Project Eclipse. Your mission: stop Eclipse before it completes **Project Ascension**—a plan to permanently eliminate humanity.

## Core Gameplay Features

### Player Mechanics
- Walk, Run, Sprint, Jump
- Crouch, Slide, Vault
- Climb Ladders & Scale Objects
- Swim
- Cover System
- Lean
- Melee & Ranged Combat
- Throwable Items
- Healing & Stamina Management
- Flashlight & Binoculars
- Lock-picking & Hacking

### Weapons
- Combat Knife
- Silenced Pistol
- Revolver
- Assault Rifle
- SMG (Submachine Gun)
- Shotgun
- Sniper Rifle
- EMP Grenade
- Smoke Grenade
- Frag Grenade
- Shock Baton

**Weapon Upgrades**: Damage, Recoil Reduction, Magazine Size, Reload Speed, Silencers, Enhanced Optics

### Enemy Types
- Patrol Drones
- Heavy Combat Robots
- Flying Reconnaissance Drones
- Turret Systems
- Security Mechs
- Corrupted Soldiers
- Elite AI Hunters
- Boss Enemies

### World Locations
- Underground Research Labs
- Ruined Metropolitan Cities
- Overgrown Suburban Areas
- Military Bunkers
- Subway Tunnels
- Abandoned Factories
- AI Data Centers
- Building Rooftops
- Flooded Zones
- Snow-Covered Mountains
- High-Security Research Facilities

### Systems
- **Inventory Management**: Weight-based carrying capacity
- **Crafting System**: Create medkits, ammo, grenades, repair kits, EMP devices
- **Experience & Skill Tree**: Level up and unlock new abilities
- **Weapon Upgrades**: Enhance existing weapons with found materials
- **Dialogue System**: Branching conversations with permanent consequences
- **Morality System**: Make ethical choices affecting story outcomes
- **Save System**: Manual, automatic, and multiple save slots
- **Dynamic AI**: State-based enemy behavior with investigation, pursuit, and tactics

## Project Structure

```
ShadowProtocol/
├── project.godot
├── .gitignore
├── Assets/
│   ├── Models/
│   ├── Materials/
│   ├── Textures/
│   ├── Audio/
│   │   ├── Music/
│   │   └── SFX/
│   ├── Sprites/
│   └── icon.svg
├── Scenes/
│   ├── Main/
│   │   ├── MainMenu.tscn
│   │   └── Game.tscn
│   ├── Player/
│   │   └── Player.tscn
│   ├── Enemies/
│   │   ├── Drone.tscn
│   │   ├── Robot.tscn
│   │   └── Enemy.tscn
│   ├── Weapons/
│   │   ├── Pistol.tscn
│   │   └── Rifle.tscn
│   ├── UI/
│   │   ├── HUD.tscn
│   │   ├── InventoryUI.tscn
│   │   └── PauseMenu.tscn
│   └── Levels/
│       ├── Lab.tscn
│       ├── City.tscn
│       └── Bunker.tscn
├── Scripts/
│   ├── Player/
│   │   ├── PlayerController.gd
│   │   ├── HealthSystem.gd
│   │   ├── InventoryManager.gd
│   │   └── StaminaSystem.gd
│   ├── AI/
│   │   ├── EnemyAI.gd
│   │   ├── AIState.gd
│   │   └── Behaviors/
│   ├── Weapons/
│   │   ├── Weapon.gd
│   │   ├── Pistol.gd
│   │   ├── Rifle.gd
│   │   └── Melee.gd
│   ├── Systems/
│   │   ├── GameManager.gd
│   │   ├── SaveLoadSystem.gd
│   │   ├── CraftingSystem.gd
│   │   ├── DialogueSystem.gd
│   │   └── QuestSystem.gd
│   └── Utilities/
│       ├── Constants.gd
│       ├── HelperFunctions.gd
│       └── EventBus.gd
├── Data/
│   ├── Quests/
│   ├── Dialogue/
│   ├── Items/
│   └── Enemies/
└── Documentation/
    ├── DEVELOPMENT.md
    ├── DESIGN_DOC.md
    └── API.md
```

## Getting Started

### Prerequisites
- Godot 4.x ([Download](https://godotengine.org/download))
- Git
- Text Editor or IDE (VSCode, JetBrains)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/benesfiazineb-cpu/shadow-protocol.git
   cd shadow-protocol
   ```

2. **Open in Godot**:
   - Launch Godot 4
   - Click "Open" → Select the `shadow-protocol` folder
   - Click "Open as Project"

3. **Run the game**:
   - Press `F5` or click the Play button
   - The game will launch from the main scene

## Input Map

| Action | Key(s) | Description |
|--------|--------|-------------|
| Move Forward | W | Move player forward |
| Move Backward | S | Move player backward |
| Move Left | A | Move player left |
| Move Right | D | Move player right |
| Jump | Space | Jump |
| Crouch | Ctrl | Toggle crouch |
| Sprint | Shift | Sprint (while moving) |
| Interact | E | Interact with objects |
| Fire | Left Mouse | Fire equipped weapon |
| Aim | Right Mouse | Aim weapon |
| Reload | R | Reload weapon |
| Pause | ESC | Pause game |
| Inventory | I | Open inventory |

## Core Scripts Overview

### Player System (`Scripts/Player/`)
- **PlayerController.gd**: Handles all player movement and input
- **HealthSystem.gd**: Manages player health and damage
- **InventoryManager.gd**: Manages items, equipment, and crafting
- **StaminaSystem.gd**: Tracks and manages player stamina

### AI System (`Scripts/AI/`)
- **EnemyAI.gd**: Main state machine for enemy behavior
- **AIState.gd**: Enum and helper for AI states
- **Behaviors/**: Individual behavior scripts for different enemy types

### Weapons System (`Scripts/Weapons/`)
- **Weapon.gd**: Base weapon class with firing, reloading, and upgrades
- **Pistol.gd**, **Rifle.gd**, **Melee.gd**: Specific weapon implementations

### Game Systems (`Scripts/Systems/`)
- **GameManager.gd**: Global game state and progression
- **SaveLoadSystem.gd**: Handles save/load functionality
- **CraftingSystem.gd**: Crafting recipes and mechanics
- **DialogueSystem.gd**: Dialogue branching and choices
- **QuestSystem.gd**: Quest tracking and objectives

### Utilities (`Scripts/Utilities/`)
- **Constants.gd**: Game-wide constants and enums
- **HelperFunctions.gd**: Utility functions
- **EventBus.gd**: Central event signaling system

## Development Roadmap

### Phase 1: Core Systems (Current)
- [x] Project structure
- [ ] Player controller with movement
- [ ] Basic enemy AI
- [ ] Weapon system with firing/reloading
- [ ] Inventory and item management
- [ ] Save/load system

### Phase 2: Content & Features
- [ ] Level design (5 main chapters)
- [ ] Dialogue system implementation
- [ ] Crafting system
- [ ] Skill tree and upgrades
- [ ] Audio system (music, SFX, voice)

### Phase 3: Polish & Optimization
- [ ] UI/UX refinement
- [ ] Visual effects and particles
- [ ] Performance optimization
- [ ] Bug fixing and testing
- [ ] Final balance adjustments

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -m "Add your feature"`
3. Push to branch: `git push origin feature/your-feature`
4. Open a Pull Request

## Code Style Guidelines

- Use **PascalCase** for class names
- Use **snake_case** for variable and function names
- Use **SCREAMING_SNAKE_CASE** for constants
- Add comments for complex logic
- Keep functions focused and modular
- Use signals for inter-system communication

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact & Support

For questions, issues, or suggestions, please open an issue on GitHub.

---

**Last Updated**: 2026-07-10
**Version**: 0.1.0 (Alpha)

# Shadow Protocol - Complete README

## 📋 Table of Contents
1. [Overview](#overview)
2. [Installation](#installation)
3. [Getting Started](#getting-started)
4. [Project Structure](#project-structure)
5. [Controls](#controls)
6. [Systems Overview](#systems-overview)
7. [Development](#development)
8. [Contributing](#contributing)

---

## Overview

**SHADOW PROTOCOL** is a complete third-person action-adventure game built with **Godot 4** and **GDScript**.

### Game Concept
Set in 2089, you awaken in an underground lab with no memory. As you progress, you discover you engineered the Eclipse AI—a being designed to end wars that instead concluded humanity itself was the threat. Now you must navigate a destroyed world to stop Project Ascension before the AI completes its plan to wipe out humanity permanently.

### Key Features
✅ **Dynamic Combat System** - Ranged, melee, and throwable weapons  
✅ **Advanced AI Enemies** - State-based AI with investigation, chase, and tactical behaviors  
✅ **Deep Crafting System** - Create ammo, medkits, grenades, and upgrades  
✅ **Dialogue & Moral Choices** - Branching conversations with consequences  
✅ **Quest System** - 5 main chapters + side missions  
✅ **Save/Load System** - Auto-save + 10 manual slots  
✅ **Adaptive Audio** - Dynamic music and positional sound  
✅ **UI/Inventory** - Full inventory management with weight tracking  
✅ **Progression** - Experience, skills, and weapon upgrades  

---

## Installation

### Requirements
- **Godot 4.1+** (Download: https://godotengine.org/download)
- **Git** (For version control)
- **At least 2GB disk space**

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/benesfiazineb-cpu/shadow-protocol.git
   cd shadow-protocol
   ```

2. **Open in Godot**
   - Launch Godot 4
   - Click "Open Project"
   - Navigate to the `shadow-protocol` folder
   - Click "Open as Project"

3. **Verify Installation**
   - Check the Scene Tree (left panel)
   - Should show Project folder structure
   - No error messages in Output tab

---

## Getting Started

### Running the Game

1. **Run the Main Scene**
   - Click the **Play** button (▶) in the top-right corner
   - Or press **F5**
   - Game will start with MainMenu scene

2. **From Main Menu**
   - Click "New Game" to start fresh
   - "Continue" to load last save
   - "Settings" for audio/video options
   - "Quit" to exit

### First Playthrough Tips
- Take your time exploring
- Listen to audio logs for story context
- Manage your inventory - weight matters
- Try stealth before combat
- Check the pause menu (ESC) for quest log

---

## Project Structure

```
shadow-protocol/
├── project.godot                 # Godot project config
├── README.md                     # This file
│
├── Assets/                       # Game assets
│   ├── Models/                   # 3D models
│   ├── Materials/                # PBR materials
│   ├── Textures/                 # Textures and sprites
│   ├── Audio/                    # Music and SFX
│   │   ├── Music/
│   │   └── SFX/
│   └── Sprites/                  # UI sprites
│
├── Scenes/                       # Godot scene files
│   ├── Main/
│   │   ├── MainMenu.tscn        # Main menu scene
│   │   └── Game.tscn            # Main game scene
│   ├── Player/
│   │   └── Player.tscn          # Player scene
│   ├── Enemies/
│   │   ├── Enemy.tscn           # Base enemy scene
│   │   ├── Drone.tscn           # Patrol drone
│   │   └── Robot.tscn           # Heavy robot
│   ├── Weapons/
│   │   ├── Weapon.tscn          # Base weapon
│   │   ├── Pistol.tscn
���   │   ├── Rifle.tscn
│   │   └── Shotgun.tscn
│   ├── UI/
│   │   ├── HUD.tscn             # Main HUD
│   │   ├── InventoryUI.tscn     # Inventory screen
│   │   ├── PauseMenu.tscn       # Pause menu
│   │   └── MainMenu.tscn        # Main menu
│   └── Levels/
│       ├── Lab.tscn             # Chapter 1
│       ├── City.tscn            # Chapter 2
│       └── ...
│
├── Scripts/                      # All GDScript files
│   ├── Player/
│   │   ├── PlayerController.gd   # Movement
│   │   ├── HealthSystem.gd       # Health/damage
│   │   ├── StaminaSystem.gd      # Stamina/sprint
│   │   └── InventoryManager.gd   # Inventory
│   ├── AI/
│   │   ├── EnemyAI.gd            # Base enemy AI
│   │   ├── PatrolDrone.gd        # Drone variant
│   │   └── HeavyRobot.gd         # Robot variant
│   ├── Weapons/
│   │   ├── Weapon.gd             # Base weapon
│   │   ├── Pistol.gd
│   │   ├── Rifle.gd
│   │   ├── Shotgun.gd
│   │   ├── SniperRifle.gd
│   │   └── Melee.gd
│   ├── Systems/
│   │   ├── GameManager.gd        # Game state
│   │   ├── SaveLoadSystem.gd     # Save/load
│   │   ├── CraftingSystem.gd     # Crafting
│   │   ├── DialogueSystem.gd     # Dialogue
│   │   ├── QuestSystem.gd        # Quests
│   │   └── AudioManager.gd       # Audio
│   ├── UI/
│   │   ├── HUD.gd                # HUD display
│   │   ├── InventoryUI.gd        # Inventory UI
│   │   ├── PauseMenu.gd          # Pause menu
│   │   └── MainMenu.gd           # Main menu
│   └── Utilities/
│       ├── Constants.gd          # Game constants
│       ├── HelperFunctions.gd    # Utility functions
│       └── EventBus.gd           # Event system
│
├── Data/                         # Game data (JSON)
│   ├── Items/
│   │   └── items_database.json
│   ├── Quests/
│   │   └── quests_database.json
│   └── Dialogue/
│       └── dialogue_database.json
│
└── Documentation/
    ├── DEVELOPMENT.md            # Dev guide
    ├── DESIGN_DOC.md             # Game design
    ├── LEVEL_DESIGN.md           # Level layout
    └── API.md                    # API reference
```

---

## Controls

| Action | Key | Description |
|--------|-----|-------------|
| **Move Forward** | W | Move player forward |
| **Move Backward** | S | Move player backward |
| **Move Left** | A | Strafe left |
| **Move Right** | D | Strafe right |
| **Jump** | Space | Jump (20° angle max) |
| **Crouch** | Ctrl | Toggle crouch mode |
| **Sprint** | Shift | Sprint (while moving) |
| **Fire** | LMB | Fire equipped weapon |
| **Aim** | RMB | Aim down sights |
| **Reload** | R | Reload weapon |
| **Interact** | E | Interact with objects |
| **Inventory** | I | Open inventory |
| **Pause** | ESC | Pause/unpause game |
| **Flashlight** | F | Toggle flashlight |
| **Melee Attack** | V | Melee attack |

---

## Systems Overview

### Combat System
- **Weapon Types**: Pistol, Rifle, Shotgun, Sniper, Melee
- **Damage Calculation**: Base damage × multipliers (upgrades, distance, difficulty)
- **Ammo Management**: Limited ammo per magazine + reserve pool
- **Reload Mechanics**: Interruption possible, manual reload recommended

### AI System
- **States**: PATROL → INVESTIGATE → CHASE → ATTACK
- **Detection**: Sight-based (raycast) + hearing-based (distance + sound level)
- **Behavior**: Coordinate with nearby allies, use cover, retreat when damaged

### Inventory System
- **Weight-Based**: 50 kg carrying capacity
- **Item Types**: Weapons, Ammo, Consumables, Materials, Misc
- **Stackable Items**: Ammo, medkits, materials can stack
- **Equipment Slots**: Primary, Secondary, Melee, Throwable

### Crafting System
- **Recipes**: 6 main recipes (medkits, ammo, grenades, etc.)
- **Ingredients**: Found throughout world
- **Time**: Crafting takes real time (can be interrupted)
- **Upgrades**: Apply to weapons (damage, fire rate, reload time)

### Save System
- **Auto-Save**: Every 5 minutes
- **Manual Save**: 10 slots available
- **Persistent State**: World changes save
- **Quest Progress**: Automatically tracked

---

## Development

### Setting Up Development

1. **Install Dependencies**
   - Godot 4.1+ (required)
   - Git (recommended)

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Edit scripts in `Scripts/` folder
   - Create scenes in `Scenes/` folder
   - Follow naming conventions (see DEVELOPMENT.md)

4. **Commit & Push**
   ```bash
   git add .
   git commit -m "feat(system): Add new feature"
   git push origin feature/your-feature-name
   ```

5. **Create Pull Request**
   - Go to GitHub repository
   - Click "New Pull Request"
   - Describe your changes
   - Request review

### Code Quality
- Follow GDScript style guide
- Use meaningful variable names
- Comment complex logic
- Test all changes before committing

---

## Contributing

Contributions are welcome! Please:

1. **Check Issues** - See what needs work
2. **Fork Repository** - Create your own copy
3. **Create Branch** - Feature or bugfix branch
4. **Make Changes** - With clear commits
5. **Test Thoroughly** - Verify nothing breaks
6. **Submit PR** - With detailed description

### Areas Needing Help
- 3D Models and animations
- Texture creation
- Level design
- Sound design
- UI/UX polish
- Bug fixes

---

## Known Issues

- [ ] Enemy pathfinding needs optimization
- [ ] Some audio files not yet implemented
- [ ] UI scaling on ultra-wide monitors
- [ ] Performance on older GPUs needs testing

---

## Roadmap

### v0.2.0 (Next Release)
- [ ] Complete level 1 environment
- [ ] Add music tracks
- [ ] Voice acting for main character
- [ ] Advanced enemy types
- [ ] Checkpoint system

### v0.5.0
- [ ] All 5 chapters complete
- [ ] Final boss implementation
- [ ] Multiple endings
- [ ] Achievement system

### v1.0.0
- [ ] Full game release
- [ ] Bug fixes and balance
- [ ] DLC quest pack
- [ ] Leaderboards

---

## License

MIT License - See LICENSE file for details

---

## Credits

- **Developer**: benesfiazineb-cpu
- **Engine**: Godot 4.x
- **Inspiration**: Deus Ex, Cyberpunk, System Shock

---

## Support & Contact

- **GitHub Issues**: Report bugs here
- **Discussions**: Ask questions in GitHub Discussions
- **Email**: benesfiazineb@gmail.com

---

**Last Updated**: 2026-07-10  
**Current Version**: 0.1.0 (Alpha)

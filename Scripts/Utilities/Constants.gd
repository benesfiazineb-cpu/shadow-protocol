# Scripts/Utilities/Constants.gd
extends Node

class_name Constants

# --- Game Settings ---
const GAME_TITLE: String = "Shadow Protocol"
const GAME_VERSION: String = "0.1.0"
const TARGET_FPS: int = 60
const GAME_DURATION_HOURS: float = 5.0

# --- Difficulty ---
enum Difficulty { EASY, NORMAL, HARD, NIGHTMARE }
const DEFAULT_DIFFICULTY: Difficulty = Difficulty.NORMAL

# --- World ---
const GRAVITY: float = 20.0
const WORLD_UP: Vector3 = Vector3.UP

# --- Player Settings ---
const PLAYER_MAX_HEALTH: float = 100.0
const PLAYER_MAX_STAMINA: float = 100.0
const PLAYER_INVENTORY_MAX_WEIGHT: float = 50.0

# --- Movement Speeds ---
const WALK_SPEED: float = 5.0
const RUN_SPEED: float = 8.0
const SPRINT_SPEED: float = 12.0
const CROUCH_SPEED: float = 2.5
const CLIMB_SPEED: float = 3.0

# --- AI Settings ---
const AI_PATROL_SPEED: float = 3.0
const AI_CHASE_SPEED: float = 5.0
const AI_SIGHT_RANGE: float = 25.0
const AI_HEARING_RANGE: float = 20.0
const AI_ATTACK_RANGE: float = 10.0

# --- Game Chapters ---
enum Chapter { AWAKENING, ESCAPE, DISCOVERY, CONFRONTATION, ASCENSION }
const CHAPTER_NAMES: Dictionary = {
	Chapter.AWAKENING: "The Awakening",
	Chapter.ESCAPE: "Escape from the Lab",
	Chapter.DISCOVERY: "Discoveries in the Ruins",
	Chapter.CONFRONTATION: "Confrontation",
	Chapter.ASCENSION: "Project Ascension",
}

# --- Item Types ---
enum ItemType { CONSUMABLE, WEAPON_MELEE, WEAPON_RANGED, AMMO, MATERIAL, MISC, QUEST_ITEM }

# --- Enemy Types ---
enum EnemyType { PATROL_DRONE, HEAVY_ROBOT, FLYING_DRONE, TURRET, SECURITY_MECH, CORRUPTED_SOLDIER, ELITE_HUNTER, BOSS }

# --- Weapon Types ---
enum WeaponType { MELEE, PISTOL, REVOLVER, RIFLE, SMG, SHOTGUN, SNIPER, EXPLOSIVE }

# --- Status Effects ---
enum StatusEffect { BLEEDING, POISONED, STUNNED, BURNED, FROZEN, SILENCED }

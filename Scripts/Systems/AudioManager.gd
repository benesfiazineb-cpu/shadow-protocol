# Scripts/Systems/AudioManager.gd
extends Node

class_name AudioManager

# --- Audio Buses ---
const MASTER_BUS = "Master"
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"
const VOICE_BUS = "Voice"

# --- Audio Players ---
var background_music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var voice_player: AudioStreamPlayer
var ambient_player: AudioStreamPlayer

# --- Current State ---
var current_music: String = ""
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var voice_volume: float = 1.0
var ambient_volume: float = 1.0
var master_volume: float = 1.0

# --- Music Tracks ---
var music_tracks: Dictionary = {
	"main_menu": "res://Assets/Audio/Music/main_menu.ogg",
	"lab_exploration": "res://Assets/Audio/Music/lab_exploration.ogg",
	"tension": "res://Assets/Audio/Music/tension.ogg",
	"combat": "res://Assets/Audio/Music/combat.ogg",
	"boss_battle": "res://Assets/Audio/Music/boss_battle.ogg",
}

# --- SFX Tracks ---
var sfx_tracks: Dictionary = {
	"footstep_metal": "res://Assets/Audio/SFX/footstep_metal.ogg",
	"footstep_concrete": "res://Assets/Audio/SFX/footstep_concrete.ogg",
	"weapon_fire_pistol": "res://Assets/Audio/SFX/weapon_fire_pistol.ogg",
	"weapon_fire_rifle": "res://Assets/Audio/SFX/weapon_fire_rifle.ogg",
	"weapon_reload": "res://Assets/Audio/SFX/weapon_reload.ogg",
	"ui_click": "res://Assets/Audio/SFX/ui_click.ogg",
	"ui_hover": "res://Assets/Audio/SFX/ui_hover.ogg",
}

# --- Signals ---
signal music_changed(track_name: String)
signal volume_changed(bus: String, volume: float)

func _ready() -> void:
	# Create audio stream players if they don't exist
	background_music_player = AudioStreamPlayer.new()
	background_music_player.bus = MUSIC_BUS
	add_child(background_music_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = SFX_BUS
	add_child(sfx_player)
	
	voice_player = AudioStreamPlayer.new()
	voice_player.bus = VOICE_BUS
	add_child(voice_player)
	
	ambient_player = AudioStreamPlayer.new()
	ambient_player.bus = SFX_BUS
	ambient_player.stream_paused = true
	add_child(ambient_player)
	
	# Set initial volumes
	set_bus_volume(MASTER_BUS, master_volume)
	set_bus_volume(MUSIC_BUS, music_volume)
	set_bus_volume(SFX_BUS, sfx_volume)
	set_bus_volume(VOICE_BUS, voice_volume)

func play_music(track_name: String, fade_duration: float = 1.0) -> void:
	if not music_tracks.has(track_name):
		print("Music track not found: " + track_name)
		return
	
	if current_music == track_name and background_music_player.playing:
		return
	
	var track_path = music_tracks[track_name]
	
	# Fade out current music if playing
	if background_music_player.playing and fade_duration > 0.0:
		var tween = create_tween()
		tween.tween_property(background_music_player, "volume_db", -80, fade_duration)
		tween.tween_callback(func(): background_music_player.stop())
	
	# Load and play new music
	current_music = track_name
	background_music_player.stream = load(track_path)
	background_music_player.volume_db = 0.0
	background_music_player.play()
	
	emit_signal("music_changed", track_name)
	print("Now playing: " + track_name)

func stop_music(fade_duration: float = 1.0) -> void:
	if fade_duration > 0.0:
		var tween = create_tween()
		tween.tween_property(background_music_player, "volume_db", -80, fade_duration)
		tween.tween_callback(func(): background_music_player.stop())
	else:
		background_music_player.stop()
	
	current_music = ""

func play_sfx(sfx_name: String) -> void:
	if not sfx_tracks.has(sfx_name):
		print("SFX track not found: " + sfx_name)
		return
	
	var track_path = sfx_tracks[sfx_name]
	sfx_player.stream = load(track_path)
	sfx_player.play()

func play_voice(voice_line: String) -> void:
	var track_path = "res://Assets/Audio/Voice/" + voice_line + ".ogg"
	if ResourceLoader.exists(track_path):
		voice_player.stream = load(track_path)
		voice_player.play()
	else:
		print("Voice line not found: " + voice_line)

func set_bus_volume(bus: String, volume: float) -> void:
	volume = clamp(volume, 0.0, 1.0)
	var bus_idx = AudioServer.get_bus_index(bus)
	
	if bus_idx != -1:
		var volume_db = linear2db(volume) if volume > 0.0 else -80.0
		AudioServer.set_bus_volume_db(bus_idx, volume_db)
	
	match bus:
		MASTER_BUS:
			master_volume = volume
		MUSIC_BUS:
			music_volume = volume
		SFX_BUS:
			sfx_volume = volume
		VOICE_BUS:
			voice_volume = volume
	
	emit_signal("volume_changed", bus, volume)

func get_bus_volume(bus: String) -> float:
	match bus:
		MASTER_BUS:
			return master_volume
		MUSIC_BUS:
			return music_volume
		SFX_BUS:
			return sfx_volume
		VOICE_BUS:
			return voice_volume
		_:
			return 1.0

func is_music_playing() -> bool:
	return background_music_player.playing

func get_current_music() -> String:
	return current_music

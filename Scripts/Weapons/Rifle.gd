# Scripts/Weapons/Rifle.gd
extends "res://Scripts/Weapons/Weapon.gd"

class_name Rifle

func _ready() -> void:
	weapon_name = "Assault Rifle"
	damage = 20.0
	fire_rate = 3.0
	reload_time = 2.0
	max_ammo_in_clip = 30
	max_reserve_ammo = 180
	fire_mode = "full_auto"
	current_ammo_in_clip = max_ammo_in_clip
	
	# Initialize timers
	fire_timer = Timer.new()
	fire_timer.wait_time = 1.0 / fire_rate
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)

	reload_timer = Timer.new()
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	add_child(reload_timer)

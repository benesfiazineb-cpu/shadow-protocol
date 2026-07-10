# Scripts/Weapons/Pistol.gd
extends "res://Scripts/Weapons/Weapon.gd"

class_name Pistol

func _ready() -> void:
	weapon_name = "Silenced Pistol"
	damage = 15.0
	fire_rate = 2.0
	reload_time = 1.2
	max_ammo_in_clip = 12
	max_reserve_ammo = 120
	fire_mode = "semi_auto"
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

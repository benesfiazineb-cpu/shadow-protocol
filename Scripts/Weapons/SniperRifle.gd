# Scripts/Weapons/SniperRifle.gd
extends "res://Scripts/Weapons/Weapon.gd"

class_name SniperRifle

func _ready() -> void:
	weapon_name = "Sniper Rifle"
	damage = 75.0
	fire_rate = 0.5
	reload_time = 3.0
	max_ammo_in_clip = 5
	max_reserve_ammo = 50
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

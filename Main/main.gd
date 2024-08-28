extends Node2D

var PLANETS : Array = [
	preload("res://Elements/Planets/BasicGreenPlanet/basic_green_planet.tscn"),
	preload("res://Elements/Planets/BluePlanet/blue_planet.tscn"),
	preload("res://Elements/Planets/PlanetEarth/planet_earth.tscn"),
	preload("res://Elements/Planets/PlanetSaturn/planet_saturn.tscn"),
	preload("res://Elements/Planets/RedPlanet/red_planet.tscn")
]

@onready var comet_scene : PackedScene = load("res://Elements/BackgroundEffects/CometEffects/comet_effect.tscn")
@onready var enemy_scene : PackedScene = preload("res://Elements/Enemies/enemy.tscn")
@onready var coin_scene : PackedScene = preload("res://Elements/Coin/coin.tscn")
@onready var space_ship_scene : PackedScene = load("res://Elements/space_ship/space_ship.tscn")
@onready var space_ship : RigidBody2D = $SpaceShip
@onready var start: Label = %Start
@onready var camera = %Camera2D

var coin_spawn_radius : float = 9500.0
var planet_radius_by_spawn : float = 8500.0
var enemy_spawn_radius : float = 60.0
var last_spawned_coin
var additional_radius_between_planets : float = 800
var planets_positions = []

func _ready():
	%TimerForComet.wait_time = 0.5 #randf_range(5.0, 10.0)
	
	spawn_planets()
	space_ship.global_position.y = 100
	spawn_coin()
	
	%TimerForComet.timeout.connect(_on_timer_for_comet_timeout)
	Events.coin_pickup.connect(spawn_coin)


func spawn_planets():
	var planets_count = randi_range(5, 15)
	for planet_num in range(planets_count):
		var new_pos = Geometry.get_rand_vec(planet_radius_by_spawn)
		var is_ok = false
		
		var timeout = 500
		var planet_instant =  null
		for try in timeout:
			if planet_instant == null:
				planet_instant = PLANETS[randi_range(0, PLANETS.size() - 1)].instantiate()
			var radius = planet_instant.radius
			
			if is_position_empty_for_planet(new_pos, radius + additional_radius_between_planets):
				#var planet_instant = PLANETS.pick_random()
				
				
				add_child(planet_instant, true)
				planet_instant.global_position = new_pos
				var dict = {
					"position": new_pos,
					'radius': radius
				}
				planets_positions += [dict]
				is_ok = true
				planet_instant = null
				break
		#if not is_ok: print_debg("НЕ ХВАТИЛО МЕСТА ДЛЯ СПАВНА ПЛАНЕТЫ")


func is_position_empty_for_planet(pos: Vector2, radius1: float) -> bool:
	for planet_dict in planets_positions:
		var delta = (planet_dict["position"] as Vector2).distance_to(pos)
		if delta < (radius1 + planet_dict['radius']):
			return false
	return true


func set_camera_remote_transform(_r_transform: RemoteTransform2D):
	var _remote_t = _r_transform
	var _path = _remote_t.get_path_to(camera)
	_remote_t.set_remote_node(_path)
	camera.position_smoothing_enabled = Global.SETTINGS["CameraSmoothing"]
	camera.zoom = Vector2(Global.SETTINGS['CameraZoom'], Global.SETTINGS['CameraZoom'])


func spawn_coin():
	var coin_instant : Area2D = coin_scene.instantiate()
	var enemy_instant : CharacterBody2D = enemy_scene.instantiate()
	await get_tree().process_frame
	add_child(coin_instant, true)
	await get_tree().process_frame
	add_child(enemy_instant, true)
	last_spawned_coin = coin_instant
	
	var coin_position = Vector2(randf_range(-coin_spawn_radius, coin_spawn_radius),\
	randf_range(-coin_spawn_radius, coin_spawn_radius))
	var enemy_position = Vector2(coin_position)
	
	coin_instant.global_position = coin_position
	enemy_instant.global_position = coin_position
	enemy_instant.tween_moving()
	
	Global.update_coin_position(coin_position)


func game_over():
	get_tree().paused = true
	MainHud.death_window.show()


func run_comet():
	var comet_intant : CanvasLayer = comet_scene.instantiate()
	add_child(comet_intant, true)


func _on_timer_for_comet_timeout():
	run_comet()

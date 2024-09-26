extends Node2D

var PLANETS : Array = [
	preload("res://Elements/Planets/BasicGreenPlanet/basic_green_planet.tscn"),
	preload("res://Elements/Planets/BluePlanet/blue_planet.tscn"),
	preload("res://Elements/Planets/PlanetEarth/planet_earth.tscn"),
	preload("res://Elements/Planets/PlanetSaturn/planet_saturn.tscn"),
	preload("res://Elements/Planets/RedPlanet/red_planet.tscn")
]

var GARBAGES := [
	preload("res://Elements/Environments/Garbages/BasicGarbage/basic_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/1_Garbage/1_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/2_Garbage/2_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/4_Garbage/4_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/5_Garbage/5_garbage.tscn"),
	preload("res://Elements/Environments/Garbages/8_Garbage/8_garbage.tscn")
]

var OBJECT_POOL := []
var POOL_MAX_SIZE = 100
var POOL_POINTER = 0

@onready var timer_for_garbage: Timer = %TimerForGarbage
@onready var garbage_spawner_scene := preload("res://Elements/Environments/Garbages/GarbagesSpawner/garbages_spawner.tscn")
@onready var comet_scene : PackedScene = load("res://Elements/BackgroundEffects/CometEffects/comet_effect.tscn")
@onready var enemy_scene : PackedScene = preload("res://Elements/Enemies/enemy.tscn")
@onready var coin_scene : PackedScene = preload("res://Elements/Coin/coin.tscn")
@onready var space_ship_scene : PackedScene = load("res://Elements/space_ship/space_ship.tscn")
@onready var space_ship: RigidBody2D = %SpaceShip
@onready var start: Label = %Start
@onready var camera = %Camera2D

var coin_instant : Area2D
var distance_to_coin
var coin_spawn_radius : float = 9500.0
var planet_radius_by_spawn : float = 8500.0
var enemy_spawn_radius : float = 60.0
var last_spawned_coin
var additional_radius_between_planets : float = 800
var planets_positions = []
var garbage_position


func _ready():
	
	timer_for_garbage.timeout.connect(_on_timer_for_garbage_timeout)
	%TimerForComet.timeout.connect(_on_timer_for_comet_timeout)
	Events.coin_pickup.connect(spawn_coin)
	
	space_ship.global_position.y = 100
	
	#Global.spawn_asteroids_area()
	
	%TimerForComet.wait_time = randf_range(5.0, 10.0)
	%TimerForComet.start()
	
	spawn_planets()
	spawn_coin()
	
	setup_pool(POOL_MAX_SIZE)


func _physics_process(delta: float) -> void:
	distance_to_coin = coin_instant.global_position.distance_to(space_ship.global_position)


func spawn_planets():
	var planets_count = randi_range(5, 15)
	for planet_num in range(planets_count):
		var new_pos = Geometry.get_rand_vec(planet_radius_by_spawn)
		var is_ok = false
		
		var timeout = 500
		var planet_instance =  null
		for try in timeout:
			if planet_instance == null:
				planet_instance = PLANETS[randi_range(0, PLANETS.size() - 1)].instantiate()
			var radius = planet_instance.radius
			
			if is_position_empty(new_pos, radius + additional_radius_between_planets):
				add_child(planet_instance, true)
				planet_instance.global_position = new_pos
				
				planets_positions += [{"position": new_pos, 'radius': radius}]
				is_ok = true
				planet_instance = null
				break
		#if not is_ok: print_debg("НЕ ХВАТИЛО МЕСТА ДЛЯ СПАВНА ПЛАНЕТЫ")


func is_position_empty(pos: Vector2, radius1: float) -> bool:
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
	coin_instant = coin_scene.instantiate()
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


func set_wait_time():
	if distance_to_coin >= 5000.0:
		timer_for_garbage.wait_time = randf_range(2, 5)
	elif distance_to_coin < 5000.0 and distance_to_coin > 800.0:
		timer_for_garbage.wait_time = randf_range(4, 10)
	else:
		timer_for_garbage.wait_time = 13.0


func setup_pool(_max_size):
	POOL_MAX_SIZE = _max_size
	for el in _max_size:
		var garbage_instance = GARBAGES.pick_random().instantiate()
		OBJECT_POOL.append(garbage_instance)


func get_obj_from_pool():
	var _inst = OBJECT_POOL[POOL_POINTER]
	
	POOL_POINTER = (POOL_POINTER + 1) % POOL_MAX_SIZE
	return _inst


func run_garbage():
	var garbage_instance = get_obj_from_pool()
	if garbage_instance.get_parent():
		garbage_instance.reparent(self)
	else:
		add_child(garbage_instance, true)
	
	var offset_by_space_ship = space_ship.linear_velocity.normalized() * 800
	offset_by_space_ship = offset_by_space_ship.rotated(deg_to_rad(randf_range(-40, 40)))
	
	garbage_instance.global_position = space_ship.global_position + offset_by_space_ship


func _on_timer_for_comet_timeout():
	run_comet()


func _on_timer_for_garbage_timeout():
	set_wait_time()
	run_garbage()

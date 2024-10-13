extends Node

var PLANETS : Array = [
	preload("res://Elements/Planets/BasicGreenPlanet/basic_green_planet.tscn"),
	preload("res://Elements/Planets/BluePlanet/blue_planet.tscn"),
	preload("res://Elements/Planets/PlanetEarth/planet_earth.tscn"),
	preload("res://Elements/Planets/PlanetSaturn/planet_saturn.tscn"),
	preload("res://Elements/Planets/RedPlanet/red_planet.tscn")
]

var GARBAGES := [
	load("res://Elements/Environments/Garbages/BasicGarbage/basic_garbage.tscn"),
	load("res://Elements/Environments/Garbages/1_Garbage/1_garbage.tscn"),
	load("res://Elements/Environments/Garbages/2_Garbage/2_garbage.tscn"),
	load("res://Elements/Environments/Garbages/4_Garbage/4_garbage.tscn"),
	load("res://Elements/Environments/Garbages/5_Garbage/5_garbage.tscn"),
	load("res://Elements/Environments/Garbages/8_Garbage/8_garbage.tscn")
]

var enemy_scenes : Dictionary = {
	1: load('res://Elements/Enemies/DefaultEnemy/enemy.tscn'),
	2: load("res://Elements/Enemies/OrbitEnemy/orbit_enemy.tscn"),
	3: load("res://Elements/Enemies/SquareEnemy/square_enemy.tscn"),
	4: load("res://Elements/Enemies/TringularEnemy/tringular_enemy.tscn")
}

var asteroid_areas_count = randi_range(10, 20)
var occupied_asteroid_areas_pos := []
var area_place := 9000.0
#var asteroids_ready_flag := false
var OBJECT_POOL := []
var POOL_MAX_SIZE = 100
var POOL_POINTER = 0

var coin_scene : PackedScene = load("res://Elements/Coin/coin.tscn")
var asteroids_group_scene := load("res://Elements/Environments/AsteroidsGroup/asteroids_group.tscn")

var lvl_counter: int = 1
var garbage_instance
var coin_position
var coin_instant: Area2D
var coin_spawn_radius : float = 300.0
var planet_radius_by_spawn : float = 6500.0
var enemy_spawn_radius : float = 60.0
var last_spawned_coin
var additional_radius_between_planets : float = 800
var planets_positions = []
var garbage_position


func _ready() -> void:
	setup_pool(POOL_MAX_SIZE)
	spawn_planets()



func delete_all_object():
	for i in get_children():
		queue_free()
	return true


func spawn_coin(_pos: Vector2):
	coin_instant = coin_scene.instantiate()
	get_tree().current_scene.add_child(coin_instant, true)
	coin_position = _pos
	coin_instant.global_position = coin_position
	Global.update_coin_position(coin_position)
	last_spawned_coin = coin_position
	return coin_instant


func spawn_enemy(_pos: Vector2, _enemy_type: int = 1):
	var enemy_instant : Node2D = enemy_scenes[_enemy_type].instantiate()
	get_tree().current_scene.add_child(enemy_instant, true)
	enemy_instant.global_position = _pos
	return enemy_instant


func spawn_enemy_group(_pos: Vector2):
	pass


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
	garbage_instance = get_obj_from_pool()
	if garbage_instance.get_parent():
		garbage_instance.reparent(self)
	else:
		get_tree().current_scene.add_child(garbage_instance, true)


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
			
			if is_planet_position_empty(new_pos, radius + additional_radius_between_planets):
				get_tree().current_scene.add_child(planet_instance, true)
				planet_instance.global_position = new_pos
				
				planets_positions += [{"position": new_pos, 'radius': radius}]
				is_ok = true
				planet_instance = null
				break
		#if not is_ok: print_debg("НЕ ХВАТИЛО МЕСТА ДЛЯ СПАВНА ПЛАНЕТЫ")

func is_planet_position_empty(pos: Vector2, radius1: float) -> bool:
	for planet_dict in planets_positions:
		var delta = (planet_dict["position"] as Vector2).distance_to(pos)
		if delta < (radius1 + planet_dict['radius']):
			return false
	return true


func spawn_asteroids_area():
	var timeout := 500
	var new_position
	var asteroids_group_instance
	
	for i in asteroid_areas_count:
		new_position = Geometry.get_rand_vec(area_place)
		var is_ok := false
		asteroids_group_instance = null
		for try in timeout:
			if asteroids_group_instance == null:
				asteroids_group_instance = asteroids_group_scene.instantiate()
			var area_scene_radius = asteroids_group_instance.radius
			
			if is_asteroids_group_position_empty(new_position, 1000 + area_scene_radius):
				get_tree().current_scene.add_child(asteroids_group_instance, true)
				asteroids_group_instance.global_position = new_position
				occupied_asteroid_areas_pos = [{'position': new_position, 'radius': area_scene_radius}]
				asteroids_group_instance = null
				break

func is_asteroids_group_position_empty(_position: Vector2, _radius: float):
	for el in occupied_asteroid_areas_pos:
		var delta = (el['position'] as Vector2).distance_to(_position)
		if delta < (_radius + el['radius']): return false
	return true

extends Node

@onready var coin_scene := preload("res://Elements/Coin/coin.tscn").instantiate()
@onready var asteroids_group_scene := load("res://Elements/Environments/AsteroidsGroup/asteroids_group.tscn")

var score : int = 0
var coin_position := Vector2()

var window_is_active := false

var asteroid_areas_count = randi_range(10, 20)
var occupied_asteroid_areas_pos := []
var area_place := 9000.0
var asteroids_ready_flag := false

var Player: Node2D

var SETTINGS : Dictionary = {
	"CameraSmoothing" = false,
	
	'SelectedZoom' = 0,
	'CameraZoom' = 1.0,
	
	'Cheats' = true,
	'DistanceToCoin' = true,
	'DistanceToStart' = true,
	
	'AimingPoint' = 0,
	'AimingPointColor' = Color.YELLOW,
	
}


#func _ready() -> void:
	#get_tree().change_scene_to_file("res://Hi/hi.tscn")


func spawn_asteroids_area():
	var timeout := 500
	var new_position
	var asteroids_group_instance
	
	for i in asteroid_areas_count:
		new_position = Geometry.get_rand_vec(area_place)
		#var is_ok := false
		asteroids_group_instance = null
		for try in timeout:
			if asteroids_group_instance == null:
				asteroids_group_instance = asteroids_group_scene.instantiate()
			var area_scene_radius = asteroids_group_instance.radius
			
			if is_empty_position(new_position, 1000 + area_scene_radius):
				add_child(asteroids_group_instance, true)
				asteroids_group_instance.global_position = new_position
				occupied_asteroid_areas_pos = [{'position': new_position, 'radius': area_scene_radius}]
				asteroids_group_instance = null
				#is_ok = true
				break
	#asteroids_ready_flag = true
	#if asteroids_ready_flag:
		#breakpoint


func is_empty_position(_position: Vector2, _radius: float):
	for el in occupied_asteroid_areas_pos:
		var delta = (el['position'] as Vector2).distance_to(_position)
		if delta < (_radius + el['radius']): return false
	return true


func get_lvl():
	return get_tree().current_scene


func register_new_player(_player: Node2D, _props = {}):
	Player = _player
	
	var lvl = get_tree().get_current_scene()
	if not lvl.is_node_ready():
		await lvl.ready
	lvl.set_camera_remote_transform(Player.get_node("CameraTransform2D"))
	
	#lvl.distance_to_coin = Player.get_node("SpaceShipHUD/DistanceToCoin")
	#lvl.distance_to_start = Player.get_node("SpaceShipHUD/DistanceToStart")
	
	_player.tree_exited.connect(_on_player_exit)


func _on_player_exit():
	Player = null


func add_coin():
	score += 1
	Events.score_coin_update.emit(score)


func set_coin(value):
	score = value
	Events.score_coin_update.emit(score)


func update_coin_position(new_position: Vector2):
	coin_position = new_position

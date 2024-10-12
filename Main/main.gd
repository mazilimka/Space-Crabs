extends Node2D

@onready var timer_for_garbage: Timer = %TimerForGarbage
@onready var comet_scene : PackedScene = load("res://Elements/BackgroundEffects/CometEffects/comet_effect.tscn")
@onready var space_ship_scene : PackedScene = load("res://Elements/space_ship/space_ship.tscn")
@onready var space_ship: RigidBody2D = %SpaceShip
@onready var start: Label = %Start
@onready var camera = %Camera2D
@onready var ship_shop_area: Node2D = $ShipShopArea

var coin
var distance_to_coin
var coin_spawn_radius : float = 8000.0
var planet_radius_by_spawn : float = 8500.0
var last_spawned_coin


func _ready():
	timer_for_garbage.timeout.connect(_on_timer_for_garbage_timeout)
	%TimerForComet.timeout.connect(_on_timer_for_comet_timeout)
	Events.coin_pickup.connect(enemy_outpost)

	space_ship.global_position.y = 100
	$ShipShopArea.global_position = Vector2(randf_range(-7000, 7000), randf_range(-7000, 7000))
	#$ShipShopArea.global_position = Vector2(100, 100)
	
	Spawner.spawn_asteroids_area()
	#Global.set_coin(100)
	
	%TimerForComet.wait_time = randf_range(5.0, 10.0)
	%TimerForComet.start()
	enemy_outpost()



func _physics_process(delta: float) -> void:
	distance_to_coin = Spawner.coin_position.distance_to(space_ship.global_position)


func set_camera_remote_transform(_r_transform: RemoteTransform2D):
	var _remote_t = _r_transform
	var _path = _remote_t.get_path_to(camera)
	_remote_t.set_remote_node(_path)
	camera.zoom = Vector2(Settings.SETTINGS['CameraZoom'], Settings.SETTINGS['CameraZoom'])


func enemy_outpost():
	coin = Spawner.spawn_coin(Geometry.get_rand_vec(coin_spawn_radius))
	if Spawner.lvl_counter <= 4:
		Spawner.spawn_enemy(coin.global_position, Spawner.lvl_counter)
		Spawner.enemy_kill_counter_only += 1
	elif Spawner.lvl_counter > 4:
		for i in randi_range(1, 4):
			Spawner.spawn_enemy(coin.global_position, randi_range(1, 4))
	last_spawned_coin = Spawner.last_spawned_coin


func game_over():
	get_tree().paused = true
	MainHud.death_window.open()


func run_comet():
	var comet_intant : CanvasLayer = comet_scene.instantiate()
	add_child(comet_intant, true)


func set_wait_time():
	if distance_to_coin >= 5000.0:
		timer_for_garbage.wait_time = randf_range(1, 3)
	elif distance_to_coin < 5000.0 and distance_to_coin > 800.0:
		timer_for_garbage.wait_time = randf_range(3, 4.5)
	else:
		timer_for_garbage.wait_time = 8.0


func spawn_garbages():
	Spawner.run_garbage()
	var offset_by_space_ship = space_ship.linear_velocity.normalized() * 800
	offset_by_space_ship = offset_by_space_ship.rotated(deg_to_rad(randf_range(-40, 40)))
	Spawner.garbage_instance.global_position = space_ship.global_position + offset_by_space_ship


func _on_timer_for_comet_timeout():
	run_comet()


func _on_timer_for_garbage_timeout():
	set_wait_time()
	spawn_garbages()

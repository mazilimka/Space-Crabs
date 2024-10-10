extends Node

@onready var coin_scene := preload("res://Elements/Coin/coin.tscn").instantiate()

var score : int = 0
var coin_position := Vector2()
var window_is_active := false
var Player: Node2D
var PURCHASED_SHIP = []

var SHIP_ID := {
	'id_1' = {'name' = 'ship_1'},
	'id_2' = {'name' = 'ship_2'},
	'id_3' = {'name' = 'ship_3'},
	'id_4' = {'name' = 'ship_4'},
	'id_5' = {'name' = 'ship_5'},
	'id_6' = {'name' = 'ship_6'}
}
var SHIPS : Dictionary = {
	"ship_1" = {
		"id" = 
			1,
		'hp' = 
			100,
		'rate_of_fire' =
			0.25,
		'texture' =
			'res://Assets/Spaceships/space_ship.png',
		'mass' = 
			2.0,
		'price' = 
			0
	},
	"ship_2" = {
		"id" = 
			2,
		'hp' = 
			120,
		'rate_of_fire' =
			0.2,
		'texture' =
			"res://Assets/Spaceships/ship_1.png",
		'mass' = 
			1.7,
		'price' = 
			1
	},
	'ship_3' = {
		"id" = 
			3,
		'hp' = 
			140,
		'rate_of_fire' =
			0.19,
		'texture' =
			"res://Assets/Spaceships/ship_2.png",
		'mass' = 
			1.4,
		'price' = 
			3
	},
	'ship_4' = {
		"id" = 
			4,
		'hp' = 
			160,
		'rate_of_fire' =
			0.18,
		'texture' =
			"res://Assets/Spaceships/ship_3.png",
		'mass' = 
			1.0,
		'price' =
			 5
	},
	'ship_5' = {
		"id" = 
			5,
		'hp' = 
			170,
		'rate_of_fire' =
			0.17,
		'texture' =
			"res://Assets/Spaceships/Spaceship#01(24x24).png",
		'mass' = 
			0.5,
		'price' = 
			6
	},
	'ship_6' = {
		"id" = 
			6,
		'hp' = 
			10000,
		'rate_of_fire' =
			0.05,
		'texture' =
			"res://Assets/Spaceships/Spaceship#02(24x24).png",
		'mass' =
			0.25,
		'price' =
			 11
	}
}


#func _ready() -> void:
	#greet_win_run()


func greet_win_run():
	get_tree().change_scene_to_file("res://Hi/hi.tscn")
	MainHud.change_stage('GreetWindow')


func get_lvl():
	return get_tree().current_scene


func register_new_player(_player: Node2D, _props = {}):
	Player = _player
	
	var lvl = get_tree().get_current_scene()
	if not lvl.is_node_ready():
		await lvl.ready
	lvl.set_camera_remote_transform(Player.get_node("CameraTransform2D"))
	
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

extends Node

@onready var coin_scene := preload("res://Elements/Coin/coin.tscn").instantiate()

var score : int = 0
var coin_position := Vector2()
var is_update_check_button = false

var Player: Node2D

var SETTINGS : Dictionary = {
	"CameraSmoothing" = false,
	'SelectedZoom' = 0,
	'CameraZoom' = 1.0,
	'Cheats' = true,
	'DistanceToCoin' = true,
	'DistanceToStart' = true,
	'CursorVisibility' = 0
}

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

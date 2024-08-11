extends Node

@onready var coin_scene := preload("res://Coin/coin.tscn").instantiate()

var score : int = 0
var coin_position := Vector2()

func add_coin():
	score += 1
	Events.score_coin_update.emit(score)


func update_coin_position(new_position: Vector2):
	coin_position = new_position


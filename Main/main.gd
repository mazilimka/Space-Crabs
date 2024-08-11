extends Node2D

@onready var score_label : Label = %Score
@onready var enemy_scene : PackedScene = preload("res://Enemies/enemy.tscn")
@onready var coin_scene : PackedScene = preload("res://Coin/coin.tscn")
@onready var space_ship : RigidBody2D = $SpaceShip
@onready var distance_to_coin : Label = %DistanceToCoin
@onready var start_position : Button = %StartPosition
@onready var distance_to_start : Label = %DistanceToStart

var coin_spawn_radius : float = 2000.0
var enemy_spawn_radius : float = 60.0
var last_spawned_coin

func _ready():
	space_ship.global_position.y = 100
	Events.score_coin_update.connect(update_coin)
	spawn_coin()
	Events.coin_pickup.connect(spawn_coin)


func _process(delta):
	var _distance_to_start = Vector2($Start.global_position - space_ship.global_position)
	distance_to_start.text = str(snapped(_distance_to_start.length(), 0.001))
	
	if last_spawned_coin:
		var _distance_to_coin := Vector2(last_spawned_coin.global_position - space_ship.global_position)
		distance_to_coin.text = str(snapped(_distance_to_coin.length(), 0.01))


func spawn_coin():
	var coin_instant : Area2D = coin_scene.instantiate()
	var enemy_instant : CharacterBody2D = enemy_scene.instantiate()
	add_child(coin_instant)
	add_child(enemy_instant)
	last_spawned_coin = coin_instant
	var coin_position = Vector2(200, 200)
	#var coin_position = Vector2(randf_range(-coin_spawn_radius, coin_spawn_radius),\
	#randf_range(-coin_spawn_radius, coin_spawn_radius))
	var enemy_position = Vector2(coin_position)
	
	coin_instant.global_position = coin_position
	enemy_instant.global_position = coin_position
	
	Global.update_coin_position(coin_position)


func update_coin(coin: int):
	score_label.text = str(coin)


func _on_start_position_pressed():
	space_ship.global_position = Vector2.ZERO
	space_ship.linear_velocity = Vector2(0, 0)


func _on_button_pressed():
	if last_spawned_coin:
		space_ship.global_position = last_spawned_coin.global_position + Vector2(50, 0)
		space_ship.linear_velocity = Vector2.ZERO


func _on_restart_pressed():
	get_tree().reload_current_scene()

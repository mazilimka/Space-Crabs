extends Control

@onready var distance_to_coin: Label = %DistanceToCoin
@onready var distance_to_start: Label = %DistanceToStart


func _ready() -> void:
	distance_to_coin.visible = Global.SETTINGS['DistanceToCoin']
	distance_to_start.visible = Global.SETTINGS['DistanceToStart']
	Events.distance_to_coin.connect(distance_to_coin_hide)
	Events.distance_to_start.connect(distance_to_start_hide)


func _process(delta: float) -> void:
	if not Global.Player:
		return
	var _distance_to_start = Vector2(Global.get_lvl().start.global_position - Global.Player.global_position)
	distance_to_start.text = str(snapped(_distance_to_start.length(), 0.001))
	
	if Global.get_lvl().last_spawned_coin:
		var _distance_to_coin := Vector2(Global.get_lvl().last_spawned_coin.global_position - Global.Player.global_position)
		distance_to_coin.text = str(snapped(_distance_to_coin.length(), 0.01))


func distance_to_coin_hide(is_enabled: bool):
	distance_to_coin.visible = is_enabled


func distance_to_start_hide(is_enabled: bool):
	distance_to_start.visible = is_enabled

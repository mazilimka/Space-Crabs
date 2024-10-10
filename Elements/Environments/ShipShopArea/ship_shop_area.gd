extends Node2D


func _ready() -> void:
	$Area2D.body_entered.connect(on_area_body_entered)


func on_area_body_entered(body: Node2D):
	if body.is_in_group('Player'):
		MainHud.ship_shop.open()

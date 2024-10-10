extends Node2D

func _process(delta: float) -> void:
	look_at(Global.get_lvl().ship_shop_area.global_position)

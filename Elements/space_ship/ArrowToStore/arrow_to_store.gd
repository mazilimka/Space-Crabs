extends Node2D

#TODO: переделать с учетом тоглинга и спавна магазина
#func _ready() -> void:
	#if Global.get_lvl().ship_shop_area == null:
		#set_process(false)

func _process(_delta: float) -> void:
	look_at(Global.get_lvl().ship_shop_area.global_position)

extends Node2D


func _ready() -> void:
	if Events.GameMode.SINGLE:
		set_process(true)
		show()
	else:
		set_process(false)
		hide()


func _process(delta):
	look_at(Global.coin_position)

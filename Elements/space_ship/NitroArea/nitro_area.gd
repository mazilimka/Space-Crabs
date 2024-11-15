extends Area2D


func _ready() -> void:
	body_entered.connect(_pick_up_nitro)


func _pick_up_nitro(body):
	if body == Global.Player:
		set_nitro(body)
		queue_free()


func set_nitro(_obj: Node2D):
	var incr_speed_comp = IncreasingSpeedComponent.new()
	_obj.add_child(incr_speed_comp, true)
	incr_speed_comp.on_nitro()
	Global.nitro_counter += 1

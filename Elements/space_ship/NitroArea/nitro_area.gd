extends Area2D


func _ready() -> void:
	body_entered.connect(_pick_up_nitro)


func _pick_up_nitro(body):
	if body == Global.Player:
		body.putted_nitro.emit()
		queue_free()

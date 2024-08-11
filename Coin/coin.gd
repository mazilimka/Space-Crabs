extends Area2D


func _on_body_entered(body):
	Global.add_coin()
	Events.coin_pickup.emit()
	tween_pickup()


func tween_pickup():
	var tween = create_tween()
	tween.parallel().tween_property($Sprite2D, 'position', Vector2(0, -80), 1)
	tween.parallel().tween_property($Sprite2D, 'modulate', Color('#ffffff00'), 1)
	await tween.finished
	queue_free()

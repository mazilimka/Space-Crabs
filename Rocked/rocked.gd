extends Area2D

var SPEED := 1000.0
var velocity_direction := Vector2.RIGHT

func _physics_process(delta):
	position += velocity_direction * SPEED * delta
	#if global_position < Vector2(-10000, -10000) or global_position > Vector2(10000, 10000):
		#queue_free()


func set_direction(dir: Vector2):
	velocity_direction = dir
	rotation = dir.angle()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group('Enemies'):
		body.damage(30)
		queue_free()

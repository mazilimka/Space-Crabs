@icon("res://Assets/rocket.png")
extends Area2D

const SPEED := 1800.0

var velocity_direction := Vector2.RIGHT
var projectile_parent = null
var exceptions = []

func _physics_process(delta):
	position += velocity_direction * SPEED * delta


func set_direction(dir: Vector2, _projectile_parent = null, _exceptions = []):
	velocity_direction = dir
	rotation = dir.angle()
	projectile_parent = _projectile_parent
	exceptions = _exceptions


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body == projectile_parent:
		return
	
	for group_name in exceptions:
		if body.is_in_group(group_name):
			return
	
	if body.is_in_group('Enemies'):
		body.damage(randf_range(10.0, 30.0))
	if body.is_in_group('Player'):
		body.damage(randf_range(5.0, 12.0))
	
	queue_free()

@icon("res://Assets/rocket.png")
extends Area2D

const SPEED := 1800.0

var velocity_direction := Vector2.RIGHT
var projectile_parent = null

func _physics_process(delta):
	position += velocity_direction * SPEED * delta


func set_direction(dir: Vector2, _projectile_parent = null):
	velocity_direction = dir
	rotation = dir.angle()
	projectile_parent = _projectile_parent


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body == projectile_parent:
		return
	if body.is_in_group('Enemies'):
		body.damage(randf_range(10.0, 30.0))
	if body.is_in_group('Player'):
		body.damage(randf_range(5.0, 12.0))
	
	queue_free()

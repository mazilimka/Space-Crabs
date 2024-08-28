@icon("res://Assets/godot-invader-small.png")
extends CharacterBody2D

@onready var progress_bar : ProgressBar = $HPBar/ProgressBar
@onready var enemy_rocked_scene := preload('res://Elements/Rocked/rocked.tscn')
@onready var timer_before_shot : Timer = $TimerBeforeShot

var health := 100


func _ready():
	timer_before_shot.timeout.connect(launch_enemy_rocked)

func tween_moving():
	var start_position = global_position.x
	var tween : Tween = create_tween()
	tween.tween_property(self, 'global_position:x', start_position + 30.0, 2)
	tween.tween_property(self, 'global_position:x', start_position - 30.0, 4)
	tween.tween_property(self, 'global_position:x', start_position, 2)
	tween.set_loops()

func damage(amount: float):
	health -= amount
	update_health_bar()
	if health <= 0:
		death()

func update_health_bar():
	progress_bar.value = health

func death():
	queue_free()

func launch_enemy_rocked():
	var enemy_rocked_instant : Area2D = enemy_rocked_scene.instantiate()
	get_parent().add_child(enemy_rocked_instant)
	enemy_rocked_instant.modulate = Color.RED
	
	enemy_rocked_instant.global_position = global_position
	enemy_rocked_instant.set_direction((Global.Player.global_position - global_position).normalized(), self)

func _on_area_2d_body_entered(body):
	if body.is_in_group('Player'):
		timer_before_shot.start()

func _on_area_2d_body_exited(body):
	if body.is_in_group('Player'):
		timer_before_shot.stop()

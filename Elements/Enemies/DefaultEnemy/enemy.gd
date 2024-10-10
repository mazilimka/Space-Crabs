@icon("res://Assets/godot-invader-small.png")
extends CharacterBody2D
class_name Enemy

@onready var progress_bar : ProgressBar = $HPBar/ProgressBar
@onready var enemy_rocked_scene := preload('res://Elements/Bullet/Rocked/rocked.tscn')
@onready var timer_before_shot : Timer = $TimerBeforeShot

@export var rate_of_fire := 0.30
@export var health := 100
@export var attack_area_node : Area2D
@export var using_tween : bool = true

func _ready():
	timer_before_shot.timeout.connect(launch_enemy_rocked)
	timer_before_shot.wait_time = rate_of_fire
	
	if attack_area_node:
		attack_area_node.body_entered.connect(_on_area_2d_body_entered)
		attack_area_node.body_exited.connect(_on_area_2d_body_exited)
	else:
		$Area2D.body_entered.connect(_on_area_2d_body_entered)
		$Area2D.body_exited.connect(_on_area_2d_body_exited)


func tween_moving():
	if not using_tween:
		return
	var start_position = global_position.x
	var tween : Tween = create_tween()
	tween.tween_property(self, 'global_position:x', start_position + 30.0, 2)
	tween.tween_property(self, 'global_position:x', start_position - 30.0, 4)
	tween.tween_property(self, 'global_position:x', start_position, 2)
	tween.set_loops()


func damage(amount: float):
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, 'modulate', Color.BLACK, 0.15)
	tween.tween_property($AnimatedSprite2D, 'modulate', Color.WHITE, 0.15)
	
	health -= amount
	update_health_bar()
	if health <= 0:
		death()


func update_health_bar():
	progress_bar.value = health


func death():
	#Spawner.lvl_counter += 1
	queue_free()


func launch_enemy_rocked():
	var enemy_rocked_instant : Area2D = enemy_rocked_scene.instantiate()
	get_parent().add_child(enemy_rocked_instant)
	enemy_rocked_instant.modulate = Color.RED
	
	enemy_rocked_instant.global_position = global_position
	enemy_rocked_instant.set_direction((Global.Player.global_position - global_position).normalized(), self, ['Enemies'])


func _on_area_2d_body_entered(body):
	if body.is_in_group('Player'):
		timer_before_shot.start()


func _on_area_2d_body_exited(body):
	if body.is_in_group('Player'):
		timer_before_shot.stop()

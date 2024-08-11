extends CharacterBody2D

@onready var progress_bar : ProgressBar = $HPBar/ProgressBar

var health := 100


func _ready():
	tween_moving()


func tween_moving():
	var start_position = global_position.x
	var tween : Tween = get_tree().create_tween().set_loops()
	tween.tween_property(self, 'global_position:x', start_position + 30.0, 2)
	tween.tween_property(self, 'global_position:x', start_position - 30.0, 4)
	tween.tween_property(self, 'global_position:x', start_position, 2)
	#tween.set_loops()


func damage(amount: float):
	health -= amount
	update_health_bar()
	if health <= 0:
		death()


func update_health_bar():
	progress_bar.value = health


func death():
	queue_free()

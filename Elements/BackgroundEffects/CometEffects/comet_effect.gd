extends CanvasLayer

var random_color : Array = [
	Color.ALICE_BLUE,
	Color.BROWN,
	Color.WHITE,
	Color.CHARTREUSE,
	Color.CYAN,
	Color.FIREBRICK,
	Color.AQUA,
	Color.ALICE_BLUE,
	Color.BISQUE,
	Color.BURLYWOOD,
	Color.CHOCOLATE,
	Color.CORNSILK
]

@onready var node_2d: Node2D = %Node2D

const SPEED : float = 2000.0

var random_probability = randf_range(0, 100)
var random_start_rotation
var is_right_direction : bool = false
var move_direction = Vector2.RIGHT

func _ready() -> void:
	%VisibleOnScreenNotifier2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	
	set_random_start_position()
	set_start_rotation()
	set_random_color()


func _physics_process(delta: float) -> void:
	node_2d.position += (move_direction.normalized() * SPEED * delta)


func set_start_rotation():
	if random_probability > 50:
		random_start_rotation = deg_to_rad(remap(random_probability, 50, 100, 20, 80))
	else:
		random_start_rotation = deg_to_rad(remap(random_probability, 0, 50, 100, 160))
	#if random_start_rotation >= 1.00 and random_start_rotation <= 2.00:
		#queue_free()
	#else:
	is_right_direction = true
	node_2d.rotation = random_start_rotation
	move_direction = move_direction.rotated(random_start_rotation)


func set_random_color():
	node_2d.modulate = random_color.pick_random()


func set_random_start_position():
	var random_start_position = Vector2(randf_range(300, 860), -50)
	node_2d.global_position = random_start_position


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

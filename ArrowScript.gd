extends Node2D
class_name Arrow

@export var point : PackedVector2Array
@export var default_color : Color = Color('#ffffff')
@export var width : float = 8.0


func _draw():
	for i in range(point.size() - 1):
		draw_line(point[i], point[i + 1], default_color, width)


func _process(delta):
	queue_redraw()

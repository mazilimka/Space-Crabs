class_name Geometry
extends Node

static func get_rand_vec(radius: float):
	return Vector2(randf_range(-radius, radius), randf_range(-radius, radius))


static func _is_point_inside_area(point: Vector2, _object: Node2D) -> bool:
	var x: bool = point.x >= _object.global_position.x and point.x <= _object.global_position.x + (_object.size.x * _object.get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= _object.global_position.y and point.y <= _object.global_position.y + (_object.size.y * _object.get_global_transform_with_canvas().get_scale().y)
	return x and y

class_name Geometry
extends Node

static func get_rand_vec(radius: float):
	return Vector2(randf_range(-radius, radius), randf_range(-radius, radius))

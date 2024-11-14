extends Node

var asteroids_group_scene := load("res://Elements/Environments/AsteroidsGroup/asteroids_group.tscn")

var area_place := 9000.0
var asteroid_areas_count = randi_range(10, 20)
var occupied_asteroid_areas_pos := []


func _ready() -> void:
	spawn_asteroids_area()


func spawn_asteroids_area():
	var timeout := 500
	var new_position
	var asteroids_group_instance
	
	for i in asteroid_areas_count:
		new_position = Geometry.get_rand_vec(area_place)
		var is_ok := false
		asteroids_group_instance = null
		for try in timeout:
			if asteroids_group_instance == null:
				asteroids_group_instance = asteroids_group_scene.instantiate()
				asteroids_group_instance.spawn_asteroids()
			var area_scene_radius = asteroids_group_instance.radius
			
			if is_asteroids_group_position_empty(new_position, 1000 + area_scene_radius):
				print(get_parent())
				add_child(asteroids_group_instance, true)
				asteroids_group_instance.global_position = new_position
				occupied_asteroid_areas_pos = [{'position': new_position, 'radius': area_scene_radius}]
				asteroids_group_instance = null
				break


func is_asteroids_group_position_empty(_position: Vector2, _radius: float):
	for el in occupied_asteroid_areas_pos:
		var delta = (el['position'] as Vector2).distance_to(_position)
		if delta < (_radius + el['radius']): return false
	return true

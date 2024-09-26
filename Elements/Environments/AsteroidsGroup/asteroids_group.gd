extends Node2D


var ASTEROIDS := [
	load('res://Elements/Environments/Asteroids/2_Asteroid/second_asteroid.tscn'),
	load('res://Elements/Environments/Asteroids/3_Asteroid/third_asteroid.tscn'),
	load('res://Elements/Environments/Asteroids/4_Asteroid/fourth_asteroid.tscn'),
	load('res://Elements/Environments/Asteroids/BasicAsteroid/basic_asteroid.tscn')
]

var radius = randf_range(2000.0, 5000.0)
#var radius = 1500.0
var distance_between_asteroids = randf_range(50, 300)
#var distance_between_asteroids = 500
var asteroid_position := []


func _ready() -> void:
	spawn_asteroids()


func spawn_asteroids():
	var timeout := 50
	var new_asteroid_position
	var asteroid_radius
	
	for i in 7: # asteroids spawn amount
		var asteroid_instance = null
		var is_ok = false
		for try in timeout: # attempts for spawn asteroids
			new_asteroid_position = Geometry.get_rand_vec(radius)
			#new_asteroid_position.clamp(Vector2(2005, -2005), Vector2(2005, -2005))
			if asteroid_instance == null:
				asteroid_instance = ASTEROIDS.pick_random().instantiate()
			asteroid_radius = asteroid_instance.radius
			
			if is_empty_position(new_asteroid_position, asteroid_radius):
				add_child(asteroid_instance, true)
				asteroid_instance.global_position = new_asteroid_position
				asteroid_position += [{'position' = new_asteroid_position, 'radius' = asteroid_radius}]
				asteroid_instance = null
				is_ok = true
				break
			#if not is_ok: print('Error')
			


func is_empty_position(_position: Vector2, _radius: float):
	for asteroid in asteroid_position:
		var delta = (asteroid['position'] as Vector2).distance_to(_position)
		if delta < (_radius + asteroid['radius']):
			return false
	return true

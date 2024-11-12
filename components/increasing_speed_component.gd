extends Node
class_name IncreasingSpeedComponent

var space_ship = Global.Player
var timer_nitro = 5
var timer = 0
var nitro_is_finished := false
#var addit_accel = space_ship.accelerate + 1150.0
var ss_prev_accel


func _process(delta: float) -> void:
	timer += delta
	if (timer >= timer_nitro):
		off_nitro()
	#if (timer < timer_nitro) and not nitro_is_finished:
		#space_ship.accelerate = addit_accel
		#return
	#
	#if (timer >= timer_nitro) and not nitro_is_finished:
		#nitro_is_finished = true
		#timer = 0
	#
	#if nitro_is_finished:
		#queue_free()
		#return
	#
	#timer = 0
	#return


func on_nitro():
	ss_prev_accel = space_ship.accelerate
	space_ship.accelerate += 20000.0
	print(space_ship.accelerate)


func off_nitro():
	space_ship.accelerate = ss_prev_accel
	print(space_ship.accelerate)
	queue_free()

extends Node
class_name IncreasingSpeedComponent

var space_ship
var ss_prev_accel
var timer_nitro := 5.0
var timer := 0.0
var addit_accel := 20000.0


func _ready() -> void:
	space_ship = get_parent()
	assert(space_ship, "Нет родителя")
	on_nitro()


func _process(delta: float) -> void:
	timer += delta
	if (timer >= timer_nitro):
		off_nitro()


func on_nitro():
	ss_prev_accel = space_ship.accelerate
	space_ship.accelerate += addit_accel
	print(space_ship.accelerate)


func off_nitro():
	space_ship.accelerate = ss_prev_accel
	print(space_ship.accelerate)
	queue_free()

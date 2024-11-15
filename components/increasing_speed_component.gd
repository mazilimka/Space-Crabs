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


func _process(delta: float) -> void:
	timer += delta
	if (timer >= timer_nitro):
		if Global.nitro_counter > 1:
			off_all_nitro()
			return
		off_nitro()


func on_nitro():
	ss_prev_accel = space_ship.accelerate
	space_ship.accelerate += addit_accel
	print(space_ship.accelerate)


func off_all_nitro():
	space_ship.accelerate = space_ship.NORMAL_ACCELERATE
	for component in Global.nitro_counter:
		var _comp = space_ship.get_child(-1)
		if _comp:
			queue_free()
	Global.nitro_counter = 0


func off_nitro():
	space_ship.accelerate = space_ship.NORMAL_ACCELERATE
	print(space_ship.accelerate)
	queue_free()

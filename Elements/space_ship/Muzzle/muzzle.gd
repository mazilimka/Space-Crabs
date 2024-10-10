extends Node2D

@onready var aiming_point: Node2D = $AimingPoint

func _process(delta):
	if Settings.SETTINGS['AimingPoint'] == 0:
		aiming_point.show()
	else: aiming_point.hide()

	aiming_point.modulate = Settings.SETTINGS['AimingPointColor']


func _unhandled_input(event: InputEvent) -> void:
	var _rect : Rect2 = get_viewport().get_visible_rect()
	var camera_pos = get_viewport().get_camera_2d().get_target_position()
	var _viewport_pos = camera_pos - (_rect.size / 2)
	
	#if event is InputEventScreenTouch:
		#look_at(_viewport_pos + event.position)
		#
	#if event is InputEventScreenDrag:
		#look_at(_viewport_pos + event.position)
	
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())
	
	if event is InputEventJoypadMotion:
		var axis_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var axis_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		if Vector2(axis_x, axis_y).length() > 0.8:
			look_at(global_position + Vector2(axis_x, axis_y).normalized())

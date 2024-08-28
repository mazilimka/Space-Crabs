extends Node2D

func _process(delta: float) -> void:
	if Global.SETTINGS['CursorVisibility'] == 1:
		if Input.is_action_pressed("Control"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.is_action_just_released("Control"):
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

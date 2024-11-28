extends PanelContainer

var loading_scene := load('res://LoadingScene/loading_scene.tscn')


func _ready() -> void:
	title_tween()
	%SingleGame.pressed.connect(_single_game_pressed)
	%Multiplayer.pressed.connect(_multiplayer_pressed)
	%Settings.pressed.connect(_settings_pressed)


func _single_game_pressed():
	Events.game_mode_changed.emit(Events.GameMode.SINGLE)
	get_tree().change_scene_to_packed(loading_scene)


func _multiplayer_pressed():
	Events.game_mode_changed.emit(Events.GameMode.MULTIPLAER)
	get_tree().change_scene_to_file('res://Multiplayer/MainMP/main_mp.tscn')


func _settings_pressed():
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not Global.is_mobile:
		Global.is_mobile = true
		MainHud.show_joystick()



func title_tween():
	var tween_rot := get_tree().create_tween().set_loops(-1).set_ease(Tween.EASE_IN_OUT)
	tween_rot.tween_property(%Title, 'rotation', deg_to_rad(-10), 3)
	tween_rot.tween_property(%Title, 'rotation', deg_to_rad(+10), 3)
	
	var tween_scale := get_tree().create_tween().set_loops(-1).set_ease(Tween.EASE_IN_OUT)
	var scale_x = %Title.scale.x
	var scale_y = %Title.scale.y
	tween_scale.tween_property(%Title, 'scale', Vector2(scale_x + 0.3, scale_y + 0.3), 4)
	tween_scale.tween_property(%Title, 'scale', Vector2(scale_x, scale_y), 4)
	
	var tween_mod := get_tree().create_tween().set_loops(-1)
	tween_mod.tween_property(%Title, 'modulate', Color.YELLOW_GREEN, 2.5)
	tween_mod.tween_property(%Title, 'modulate', Color.ORANGE, 2.5)
	tween_mod.tween_property(%Title, 'modulate', Color.RED, 2.5)
	tween_mod.tween_property(%Title, 'modulate', Color.WHITE, 2)

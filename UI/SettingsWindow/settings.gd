extends PanelContainer


func _ready():
	#INFO: Синхронизация позиций кнопок по умолчанию со скриптом Global
	%AimingPointColor.color = Global.SETTINGS['AimingPointColor']
	%AimingPoint.selected = Global.SETTINGS['AimingPoint']
	%Cheats.button_pressed = Global.SETTINGS['Cheats']
	%DistanceToCoin.button_pressed = Global.SETTINGS['DistanceToCoin']
	%DistanceToStart.button_pressed = Global.SETTINGS['DistanceToStart']
	%CameraSmoothing.button_pressed = Global.SETTINGS["CameraSmoothing"]
	%CameraZoom.selected = Global.SETTINGS['SelectedZoom']
	
	%AimingPointColor.color_changed.connect(_on_aiming_point_color_color_changed)
	%AimingPoint.item_selected.connect(_on_aiming_point_item_selected)
	%Cheats.toggled.connect(_on_cheats_toggled)
	%SaveAndExit.pressed.connect(_on_save_and_exit_pressed)
	%CameraZoom.item_selected.connect(_on_camera_zoom_item_selected)
	%CameraSmoothing.toggled.connect(_on_camera_smoothing_toggled)
	%DistanceToStart.toggled.connect(_on_distance_to_start_toggled)
	%DistanceToCoin.toggled.connect(_on_distance_to_coin_toggled)


func _input(event: InputEvent) -> void:
	if event and Input.is_action_just_pressed("Escape"):
		_on_save_and_exit_pressed()
		accept_event()
		get_viewport().set_input_as_handled()
		print(get_viewport().is_input_handled())


func _on_cheats_toggled(toggled_on):
	MainHud.debug_menu.visible = toggled_on
	Global.SETTINGS['Cheats'] = toggled_on


func _on_save_and_exit_pressed():
	MainHud.death_window.show()
	MainHud.settings.hide()


func _on_camera_zoom_item_selected(index):
	Global.SETTINGS['SelectedZoom'] = index
	match index:
		0: #NOTE: 1.0
			Global.get_lvl().camera.zoom = Vector2(1.0, 1.0)
			Global.SETTINGS['CameraZoom'] = 1.0
		1: #NOTE: 1.3
			Global.get_lvl().camera.zoom = Vector2(1.3, 1.3)
			#Global.SETTINGS['CameraZoom'] = 1.3
		2: #NOTE: 1.5
			Global.get_lvl().camera.zoom = Vector2(1.5, 1.5)
			Global.SETTINGS['CameraZoom'] = 1.5


func _on_camera_smoothing_toggled(toggled_on):
	Global.get_lvl().camera.position_smoothing_enabled = toggled_on
	Global.SETTINGS["CameraSmoothing"] = toggled_on


func _on_distance_to_start_toggled(toggled_on):
	Events.distance_to_start.emit(toggled_on)
	Global.SETTINGS['DistanceToStart'] = toggled_on


func _on_distance_to_coin_toggled(toggled_on):
	Events.distance_to_coin.emit(toggled_on)
	Global.SETTINGS['DistanceToCoin'] = toggled_on


func _on_aiming_point_item_selected(index):
	Global.SETTINGS['AimingPoint'] = index


func _on_aiming_point_color_color_changed(color: Color):
	Global.SETTINGS['AimingPointColor'] = color

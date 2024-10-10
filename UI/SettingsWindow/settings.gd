extends PanelContainer


func _ready():
	#INFO: Синхронизация позиций кнопок по умолчанию со скриптом Global
	%AimingPointColor.color = Settings.SETTINGS['AimingPointColor']
	%AimingPoint.selected = Settings.SETTINGS['AimingPoint']
	%Cheats.button_pressed = Settings.SETTINGS['Cheats']
	%DistanceToCoin.button_pressed = Settings.SETTINGS['DistanceToCoin']
	%DistanceToStart.button_pressed = Settings.SETTINGS['DistanceToStart']
	%CameraZoom.selected = Settings.SETTINGS['SelectedZoom']
	
	%AimingPointColor.color_changed.connect(_on_aiming_point_color_color_changed)
	%AimingPoint.item_selected.connect(_on_aiming_point_item_selected)
	%Cheats.toggled.connect(_on_cheats_toggled)
	%SaveAndExit.pressed.connect(_on_save_and_exit_pressed)
	%CameraZoom.item_selected.connect(_on_camera_zoom_item_selected)
	%DistanceToStart.toggled.connect(_on_distance_to_start_toggled)
	%DistanceToCoin.toggled.connect(_on_distance_to_coin_toggled)


func _input(event: InputEvent) -> void:
	if get_parent().current_menu != self:
		return
	if event.is_action_pressed("Escape") and Input.is_action_just_pressed("Escape"):
		_on_save_and_exit_pressed()
		get_viewport().set_input_as_handled()


func open():
	show()
	MainHud.change_stage('Setting')
	get_parent().current_menu = self

func close():
	hide()
	MainHud.change_stage('DeathWindow')
	MainHud.death_window.open()


func _on_cheats_toggled(toggled_on):
	MainHud.debug_menu.visible = toggled_on
	Settings.SETTINGS['Cheats'] = toggled_on


func _on_save_and_exit_pressed():
	close()


func _on_camera_zoom_item_selected(index):
	Settings.SETTINGS['SelectedZoom'] = index
	match index:
		0: #NOTE: 1.0
			Global.get_lvl().camera.zoom = Vector2(1.0, 1.0)
			Settings.SETTINGS['CameraZoom'] = 1.0
		1: #NOTE: 1.3
			Global.get_lvl().camera.zoom = Vector2(1.3, 1.3)
			Settings.SETTINGS['CameraZoom'] = 1.3
		2: #NOTE: 1.5
			Global.get_lvl().camera.zoom = Vector2(1.5, 1.5)
			Settings.SETTINGS['CameraZoom'] = 1.5


func _on_distance_to_start_toggled(toggled_on):
	Events.distance_to_start.emit(toggled_on)
	Settings.SETTINGS['DistanceToStart'] = toggled_on


func _on_distance_to_coin_toggled(toggled_on):
	Events.distance_to_coin.emit(toggled_on)
	Settings.SETTINGS['DistanceToCoin'] = toggled_on


func _on_aiming_point_item_selected(index):
	Settings.SETTINGS['AimingPoint'] = index


func _on_aiming_point_color_color_changed(color: Color):
	Settings.SETTINGS['AimingPointColor'] = color

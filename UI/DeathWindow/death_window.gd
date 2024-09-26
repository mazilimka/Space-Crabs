extends PanelContainer


func _ready() -> void:
	#set_process_shortcut_input(true)
	%Back.pressed.connect(_on_back_pressed)
	%Quit.pressed.connect(_on_quit_pressed)
	%Settings.pressed.connect(_on_settings_pressed)
	%GoToTestMainScene.pressed.connect(_on_go_to_test_main_pressed)
	%GoToMainScene.pressed.connect(_on_go_to_main_pressed)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Escape"):
		#breakpoint
		accept_event()
		get_viewport().set_input_as_handled()
		_on_back_pressed()
		#get_viewport().set_handle_input_locally(false)
		#print(get_viewport().is_input_handled())


func _on_restart_game_pressed():
	get_tree().paused = false
	Global.get_lvl().get_tree().reload_current_scene()
	hide()
	Global.set_coin(0)


func _on_quit_pressed():
	Global.get_lvl().get_tree().quit()


func _on_back_pressed():
	hide()
	get_tree().paused = false


func _on_settings_pressed():
	hide()
	MainHud.settings.show()


func _on_go_to_test_main_pressed():
	get_tree().change_scene_to_file("res://TESTMAIN/testmain.tscn")
	%GoToTestMainScene.hide()
	%GoToMainScene.show()


func _on_go_to_main_pressed():
	get_tree().change_scene_to_file("res://Main/main.tscn")
	%GoToTestMainScene.show()
	%GoToMainScene.hide()

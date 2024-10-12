extends PanelContainer


func _ready() -> void:
	#set_process_shortcut_input(true)
	%Back.pressed.connect(_on_back_pressed)
	%Quit.pressed.connect(_on_quit_pressed)
	%Settings.pressed.connect(_on_settings_pressed)
	%GoToTestMainScene.pressed.connect(_on_go_to_test_main_pressed)
	%GoToMainScene.pressed.connect(_on_go_to_main_pressed)


func open():
	if Global.is_space_ship_death:
		%Back.hide()
	else: 
		%Back.show()
	show()
	MainHud.change_stage('DeathWindow')
	get_parent().current_menu = self

func close():
	hide()
	MainHud.change_stage('GameplayHud')
	get_tree().paused = false


func _input(event: InputEvent) -> void:
	if get_parent().current_menu != self:
		return
	if event.is_action_pressed("Escape") and Input.is_action_just_pressed("Escape"):
		_on_back_pressed()
		get_viewport().set_input_as_handled()


func _on_restart_game_pressed():
	Global.is_space_ship_death = false
	Global.delete_array_ship()
	Global.PURCHASED_SHIP.append(Global.SHIP_ID['id_1']['name'])
	Global.is_restart_game = true
	Global.is_continue_game = false
	
	get_tree().paused = false
	Global.get_lvl().get_tree().reload_current_scene()
	hide()
	Global.set_coin(0)


func _on_quit_pressed():
	Global.get_lvl().get_tree().quit()


func _on_back_pressed():
	close()


func _on_settings_pressed():
	hide()
	MainHud.settings.open()


func _on_go_to_test_main_pressed():
	get_tree().change_scene_to_file("res://TESTMAIN/testmain.tscn")
	%GoToTestMainScene.hide()
	%GoToMainScene.show()


func _on_go_to_main_pressed():
	get_tree().change_scene_to_file("res://Main/main.tscn")
	%GoToTestMainScene.show()
	%GoToMainScene.hide()

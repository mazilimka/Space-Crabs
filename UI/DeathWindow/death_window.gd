extends PanelContainer


func _ready() -> void:
	%Back.pressed.connect(_on_back_pressed)
	%Settings.pressed.connect(_on_settings_pressed)
	%GoToTestMainScene.pressed.connect(_on_go_to_test_main_pressed)
	%GoToMainScene.pressed.connect(_on_go_to_main_pressed)


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

extends Panel

func _ready() -> void:
	$Restart.pressed.connect(_restart_button_pressed)
	$ContinueFlying.pressed.connect(_continue_flying_button_pressed)


func _restart_button_pressed():
	Global.is_space_ship_death = false
	Global.delete_array_ship()
	Global.PURCHASED_SHIP.append(Global.SHIP_ID['id_1']['name'])
	Global.is_restart_game = true
	Global.is_continue_game = false
	Spawner.lvl_counter = 1
	Global.next_ship_id = 1
	
	get_tree().paused = false
	Global.get_lvl().get_tree().reload_current_scene()
	MainHud.change_stage('GameplayHud')


func _continue_flying_button_pressed():
	Global.is_continue_game = true
	get_tree().paused = false
	MainHud.change_stage('GameplayHud')

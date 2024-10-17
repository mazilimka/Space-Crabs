extends Panel

func _ready() -> void:
	$Restart.pressed.connect(_restart_button_pressed)
	$ContinueFlying.pressed.connect(_continue_flying_button_pressed)


func _restart_button_pressed():
	Global.global_restart()
	get_tree().paused = false
	MainHud.change_stage('GameplayHud')


func _continue_flying_button_pressed():
	Global.is_continue_game = true
	get_tree().paused = false
	MainHud.change_stage('GameplayHud')

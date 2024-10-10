extends Panel


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://Main/main.tscn')
	MainHud.change_stage('GameplayHud')

extends "res://Main/main.gd"

func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	#if OS.has_feature("windows"):
		#if Input.is_action_just_pressed("shot"):
			#print("Запуск ракеты")
	
	if event is InputEventScreenTouch:
		if event.is_pressed():
			print("Запуск ракеты")
	
	if event is InputEventScreenDrag:
		print('Run Screen Drag')

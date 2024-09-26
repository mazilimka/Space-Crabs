extends CanvasLayer

@onready var death_window: PanelContainer = %DeathWindow
@onready var settings: PanelContainer = %Settings
@onready var score: Label = %Score
@onready var debug_menu: CanvasLayer = %DebugMenu
@onready var game_pause: TextureButton = %GamePause
@onready var virtual_joystick: VirtualJoystick = %VirtualJoystick


func _ready() -> void:
	Events.score_coin_update.connect(update_coin)
	%GamePause.pressed.connect(_on_game_pause_pressed)


func _process(delta: float) -> void:
	return
	if Global.SETTINGS['ControlFor'] == 2:
		%VirtualJoystick.visible = true
	else: %VirtualJoystick.visible = false


func _input(event: InputEvent) -> void:
	if event and Input.is_action_just_pressed("Escape"):
		_on_game_pause_pressed()
		
		get_viewport().set_input_as_handled()


func _on_restart_scene_pressed() -> void:
	Global.get_lvl().get_tree().reload_current_scene()
	death_window.hide()
	Global.set_coin(0)


func _on_game_pause_pressed() -> void:
	get_tree().paused = true
	death_window.show()


func update_coin(coin: int):
	score.text = str(coin)

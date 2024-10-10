extends CanvasLayer

@onready var death_window: PanelContainer = %DeathWindow
@onready var settings: PanelContainer = %Settings
@onready var score: Label = %Score
@onready var debug_menu: CanvasLayer = %DebugMenu
@onready var game_pause: TextureButton = %GamePause
@onready var virtual_joystick: VirtualJoystick = %VirtualJoystick
@onready var ship_shop: Panel = %ShipShop

var current_stage
var current_menu = null

func _ready() -> void:
	
	
	change_stage('GameplayHud')
	Events.score_coin_update.connect(update_coin)
	%GamePause.toggled.connect(_on_game_pause_toggled)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape") and Input.is_action_just_pressed("Escape"):
		_on_game_pause_toggled(true)


func _on_restart_scene_pressed() -> void:
	Global.get_lvl().get_tree().reload_current_scene()
	death_window.hide()
	Global.set_coin(0)


func update_coin(coin: int):
	score.text = str(coin)


func _on_game_pause_toggled(toggled_on: bool) -> void:
	match toggled_on:
		true:
			get_tree().paused = true
			death_window.open()
		false:
			get_tree().paused = false
			death_window.hide()


func change_stage(_stage: String):
	match _stage:
		'GameplayHud':
			%GamePause.show()
			%Score.show()
			%DebugMenu.visible = Settings.SETTINGS['Cheats']
			#%VirtualJoystick.show()
		'ShipShop':
			%GamePause.hide()
			%Score.hide()
			%DebugMenu.hide()
			%VirtualJoystick.hide()
		'Setting':
			%GamePause.hide()
			%Score.hide()
			%DebugMenu.visible = Settings.SETTINGS['Cheats']
			%VirtualJoystick.hide()
		'DeathWindow':
			%GamePause.show()
			%Score.show()
			%DebugMenu.hide()
			%VirtualJoystick.hide()
		'GreetWindow':
			%GamePause.hide()
			%Score.hide()
			%DebugMenu.hide()
			%VirtualJoystick.hide()

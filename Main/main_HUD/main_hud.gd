extends CanvasLayer

@onready var death_window: PanelContainer = %DeathWindow
@onready var settings: PanelContainer = %Settings
@onready var score: Label = %Score
@onready var debug_menu: CanvasLayer = %DebugMenu
@onready var game_pause: TextureButton = %GamePause
@onready var virtual_joystick: VirtualJoystick = %VirtualJoystick
@onready var ship_shop: Panel = %ShipShop
@onready var ship_purchase_not: Label = %ShipPurchaseNot

var current_stage
var current_menu = null

func _ready() -> void:
	#if OS.get_name() == 'Android' or OS.get_name() == 'iOS':
		#%VirtualJoystick.show()
	#else:
		#%VirtualJoystick.hide()
	
	change_stage('GameplayHud')
	Events.score_coin_update.connect(update_coin)
	%GamePause.pressed.connect(_on_game_pause_toggled)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape") and Input.is_action_just_pressed("Escape"):
		_on_game_pause_toggled()


func update_coin(coin: int):
	score.text = str(coin)


func _on_game_pause_toggled() -> void:
	get_tree().paused = true
	death_window.open()


func launch_ship_purchase_notif():
	ship_purchase_not.show()
	var tween = create_tween()
	tween.tween_property(ship_purchase_not, 'modulate', Color('#fe934500'), 8)
	await tween.finished
	ship_purchase_not.hide()


func change_stage(_stage: String):
	match _stage:
		'GameplayHud':
			%GamePause.show()
			%Score.show()
			%Score.global_position.x = 13
			%DebugMenu.visible = Settings.SETTINGS['Cheats']
			%GameComplete.hide()
			#%VirtualJoystick.show()
		'ShipShop':
			%GamePause.hide()
			%Score.show()
			%Score.global_position.x = 0
			%DebugMenu.hide()
			#%VirtualJoystick.hide()
			%GameComplete.hide()
		'Setting':
			%GamePause.hide()
			%Score.hide()
			%DebugMenu.visible = Settings.SETTINGS['Cheats']
			#%VirtualJoystick.hide()
			%GameComplete.hide()
		'DeathWindow':
			%GamePause.show()
			%Score.show()
			%Score.global_position.x = 13
			%DebugMenu.hide()
			#%VirtualJoystick.hide()
			%GameComplete.hide()
		'GreetWindow':
			%GamePause.hide()
			%Score.hide()
			%DebugMenu.hide()
			#%VirtualJoystick.hide()
			%GameComplete.hide()
		'GameComplete':
			%GamePause.hide()
			%Score.hide()
			%DebugMenu.hide()
			#%VirtualJoystick.hide()
			%GameComplete.show()
			%ShipShop.hide()

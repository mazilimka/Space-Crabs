extends CanvasLayer

@onready var death_window: PanelContainer = %DeathWindow
@onready var settings: PanelContainer = %Settings
@onready var score: Label = %Score
@onready var debug_menu: CanvasLayer = %DebugMenu
@onready var restart_scene: TextureButton = %RestartScene
@onready var game_pause: TextureButton = %GamePause


func _ready() -> void:
	Events.score_coin_update.connect(update_coin)
	%RestartScene.pressed.connect(_on_restart_scene_pressed)
	%GamePause.pressed.connect(_on_game_pause_pressed)


func _on_restart_scene_pressed() -> void:
	Global.get_lvl().get_tree().reload_current_scene()
	death_window.hide()
	Global.set_coin(0)


func _on_game_pause_pressed() -> void:
	get_tree().paused = true
	death_window.show()


func update_coin(coin: int):
	score.text = str(coin)

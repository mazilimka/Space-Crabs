extends Control

var progress := []
var main_scene_path
var scene_loading_status := 0


func _ready() -> void:
	main_scene_path = 'res://Main/main.tscn'
	text_tween()
	await ResourceLoader.load_threaded_request(main_scene_path)


func _process(delta: float) -> void:
	scene_loading_status = ResourceLoader.load_threaded_get_status(main_scene_path, progress)
	%LoadingStatus.text = 'Loading: ' + str(floor(progress[0] * 100)) + '%'
	if scene_loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		var main_scene = ResourceLoader.load_threaded_get(main_scene_path)
		get_tree().change_scene_to_packed(main_scene)


func text_tween():
	var tween := get_tree().create_tween().set_loops()
	tween.tween_property(%LoadingStatus, 'modulate', Color.RED, 0.8)
	tween.tween_property(%LoadingStatus, 'modulate', Color.WHITE, 0.8)

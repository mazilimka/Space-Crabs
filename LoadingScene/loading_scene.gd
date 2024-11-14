extends Control

var progress := []
var main_scene_load = load('res://Main/main.tscn')
var main_scene
var main_scene_path = 'res://Main/main.tscn'
var scene_loading_status := 0


func _ready() -> void:
	Spawner.spawn_finished.connect(_on_spawn_complete)
	
	ResourceLoader.load_threaded_request(main_scene_path)


func _process(delta: float) -> void:
	scene_loading_status = ResourceLoader.load_threaded_get_status(main_scene_path, progress)
	%LoadingStatus.text = 'Loading: ' + str(floor(progress[0] * 100)) + '%'
	if scene_loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		main_scene = ResourceLoader.load_threaded_get(main_scene_path)
		#create_main_scene()


func _on_spawn_complete():
	return
	get_tree().change_scene_to_packed(main_scene)


func create_main_scene():
	var main_scene_instant = main_scene_load.instantiate()
	get_parent().add_child(main_scene_instant)
	Global.register_main_scene(get_parent().get_node('.'))


func text_tween():
	var tween := get_tree().create_tween().set_loops()
	tween.tween_property(%LoadingStatus, 'modulate', Color.RED, 0.8)
	tween.tween_property(%LoadingStatus, 'modulate', Color.WHITE, 0.8)

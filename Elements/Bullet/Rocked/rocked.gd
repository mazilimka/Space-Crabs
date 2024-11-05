@icon("res://Assets/rocket.png")
extends Area2D

const SPEED := 2000.0

var velocity_direction := Vector2.RIGHT
var projectile_parent = null
var exceptions = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_rocked_screen_exited)


func _physics_process(delta):
	position += velocity_direction * SPEED * delta


func set_direction(dir: Vector2, _projectile_parent = null, _exceptions = []):
	velocity_direction = dir
	rotation = dir.angle()
	projectile_parent = _projectile_parent
	exceptions = _exceptions


func _rocked_screen_exited():
	queue_free()


func _on_body_entered(_body):
	if _body == projectile_parent:
		return
	
	for group_name in exceptions:
		if _body.is_in_group(group_name):
			return
	
	if _body.is_in_group('Enemies'):
		_body.damaged(randf_range(10.0, 30.0))
	
	queue_free()

func _on_area_entered(area):
	if area == projectile_parent:
		return
	
	for group_name in exceptions:
		if area.is_in_group(group_name):
			return
	
	if area.is_in_group('Enemies'):
		var _area = Global.get_component(area.get_parent(), 'DamageAreaComponent')
		if _area:
			_area.damage(randf_range(10.0, 30.0))
		
	#if area
		
	if area == Global.Player.damage_area_comp:
		var _area = Global.get_component(area.get_parent(), 'DamageAreaComponent')
		if _area:
			_area.damage(randf_range(5.0, 12.0))
	
	queue_free()

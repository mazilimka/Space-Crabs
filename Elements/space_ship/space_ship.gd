@icon("res://Assets/space_ship.png")
extends RigidBody2D

@onready var marker_for_muzzle : Marker2D = %MarkerForMuzzle
@onready var sprite : Sprite2D = $Sprite2D
@onready var rocked_scene : PackedScene = preload('res://Elements/Bullet/Rocked/rocked.tscn')
@onready var fire_rate_timer : Timer = $FireRate
@onready var arrow = %Arrow
@onready var space_ship_hud: Control = $SpaceShipHUD

@export var max_health := 0
@export var health := 200.0

const ACCELERATE : float = 1800 #350.0
const DECELERATE : float = 50.0
const MAX_SPEED : float = 700.0

var rate_of_fire = Global.SHIPS['ship_1']['rate_of_fire']
var current_ship
var garbages_spawn_pos
var direction
var timer : float = 0.0
var collision_lock = false
var collided_bodies = []

func _ready():
	upgrage_ship(Global.SHIPS['ship_1'], Global.SHIP_ID['id_1'])
	
	Global.register_new_player(self)
	contact_monitor = true
	max_contacts_reported = 5

var _previous_inertia = inertia


func _physics_process(delta):
	direction = Input.get_vector('left', "right", "up", "down")
	
	if get_contact_count() == 0:
		set_prev_inertia(linear_velocity.length() * mass)
	
	if Input.is_action_just_pressed("shot") and (timer >= rate_of_fire):
		launch_rocked(get_global_mouse_position())
		timer = 0
	
	var _prev_position = global_position
	
	var dir_delta = max(0, direction.dot(linear_velocity.normalized()))
	apply_central_force(direction * ACCELERATE)# + (direction * ACCELERATE * 1 * dir_delta))
	
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
	
	if linear_velocity != Vector2.ZERO:
		sprite.rotation = linear_velocity.angle() + deg_to_rad(90)
	timer += delta
	
	$HPBar.value = health
	%HPCounter.text = str(int(health))
	
	var _coll = get_colliding_bodies()

	for el in _coll:
		if el.is_in_group('Enemies') and not collision_lock:
			damage(randf_range(0, _previous_inertia * 0.0015))
			prints("Collision force", _previous_inertia)
			collision_lock = true
			await body_exited
			collision_lock = false


func set_prev_inertia(value):
	_previous_inertia = value


func _unhandled_input(event: InputEvent) -> void:
	var _rect : Rect2 = get_viewport().get_visible_rect()
	var camera_pos = get_viewport().get_camera_2d().get_target_position()
	var _viewport_pos = camera_pos - (_rect.size / 2)
	
	#if event is InputEventScreenTouch and (timer >= rate_of_fire):
		#launch_rocked(_viewport_pos + event.position)
		#timer = 0
	#
	#if event is InputEventScreenDrag and (timer >= rate_of_fire):
		#if timer != 0:
			#launch_rocked(_viewport_pos + event.position)
			#timer = 0
	
	#if event is InputEventMouseButton and Input.is_action_just_pressed("shot") and (timer >= rate_of_fire):
		#launch_rocked(get_global_mouse_position())
		#timer = 0
	
	if Input.is_joy_known(0):
		if event is InputEventJoypadButton and Input.is_action_just_pressed("shot") and (timer >= rate_of_fire):
			var axis_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
			var axis_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
			launch_rocked(Vector2(axis_x, axis_y))
			timer = 0


func launch_rocked(_to: Vector2):
	var axis_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var axis_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	
	var rocked_instantiate := rocked_scene.instantiate()
	add_child(rocked_instantiate)
	rocked_instantiate.global_position = marker_for_muzzle.global_position
	rocked_instantiate.set_direction((_to - marker_for_muzzle.global_position).normalized(), self)
	if Input.is_joy_known(0):
		rocked_instantiate.set_direction(_to.normalized(), self)
		return


func upgrage_ship(_dict: Dictionary, _id: Dictionary):
	current_ship = _id['name']
	mass = _dict['mass']
	rate_of_fire = _dict['rate_of_fire']
	%Sprite2D.texture = load(_dict['texture'])


func update_hp_bar():
	$HPBar.value = health
	#%HPCounter.text = str(int(health))

func update_max_hp():
	$HPBar.max_value = max_health


func damage(amount: float):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, 'modulate', Color.RED, 0.1)
	tween.tween_property($Sprite2D, 'modulate', Color.WHITE, 0.1)
	
	if Input.joy_connection_changed:
		Input.start_joy_vibration(0, 0.5, 0.5, 1)
	
	health -= amount
	update_hp_bar()
	if health <= 0:
		death()
		Input.stop_joy_vibration(0)


func death():
	Global.is_space_ship_death = true
	queue_free()
	owner.game_over()

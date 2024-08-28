@icon("res://Assets/space_ship.png")
extends RigidBody2D

@onready var marker_for_muzzle : Marker2D = $Muzzle/Marker_for_muzzle
@onready var sprite : Sprite2D = $Sprite2D
@onready var rocked_scene : PackedScene = preload("res://Elements/Rocked/rocked.tscn")
@onready var fire_rate_timer : Timer = $FireRate
@onready var arrow = %Arrow

const ACCELERATE : float = 1800 #350.0
const DECELERATE : float = 50.0
const MAX_SPEED : float = 700.0

var health := 100.0
var timer : float = 0.0
var timer_wait_time = 0.2

func _ready():
	Global.register_new_player(self)
	contact_monitor = true
	max_contacts_reported = 5

var _previous_inertia = inertia

func set_prev_inertia(value):
	_previous_inertia = value

func _physics_process(delta):
	var direction = Input.get_vector('left', "right", "up", "down")
	
	if get_contact_count() == 0:
		set_prev_inertia(linear_velocity.length() * mass)
	#else:
		#linear_velocity = Vector2.ZERO
	
	var _prev_position = global_position
	
	var dir_delta = max(0, direction.dot(linear_velocity.normalized()))
	apply_central_force(direction * ACCELERATE)# + (direction * ACCELERATE * 1 * dir_delta))
	
	
	#if _prev_position != global_position:
		#linear_velocity = Vector2.ZERO
	
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
	
	if Input.is_action_just_pressed('mouse_1') and (timer >= timer_wait_time):
		launch_rocked()
		#fire_rate_timer.start()
		timer = 0
	
	if linear_velocity != Vector2.ZERO:
		sprite.rotation = linear_velocity.angle() + deg_to_rad(90)
	timer += delta
	
	var _coll = get_colliding_bodies()

	for el in _coll:
		if el.is_in_group('Enemies') and not collision_lock:
			damage(randf_range(0, _previous_inertia * 0.30))
			prints("Collision force", _previous_inertia)
			collision_lock = true
			await body_exited
			collision_lock = false

var collision_lock = false

var collided_bodies = []

func launch_rocked():
	var rocked_instantiate := rocked_scene.instantiate()
	add_child(rocked_instantiate)
	rocked_instantiate.global_position = marker_for_muzzle.global_position
	rocked_instantiate.set_direction((get_global_mouse_position() - marker_for_muzzle.global_position).normalized(), self)

func update_hp_bar():
	$HPBar.value = health

func damage(amount: float):
	health -= amount
	update_hp_bar()
	if health <= 0:
		death()

func death():
	queue_free()
	owner.game_over()

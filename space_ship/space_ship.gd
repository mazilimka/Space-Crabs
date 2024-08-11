extends RigidBody2D

@onready var marker_for_muzzle : Marker2D = $Muzzle/Marker_for_muzzle
@onready var sprite : Sprite2D = $Sprite2D
@onready var rocked_scene : PackedScene = preload("res://Rocked/rocked.tscn")
@onready var fire_rate_timer : Timer = $FireRate


const ACCELERATE : float = 50.0
const DECELERATE : float = 50.0
const MAX_SPEED : float = 800.0
const MAX_POSITION : float = 10000.0

var timer : float = 0.0
var timer_wait_time = 0.2

func _physics_process(delta):
	var direction = Input.get_vector('left', "right", "up", "down")
	
	var _prev_position = global_position
	
	apply_central_force(direction * ACCELERATE)
	global_position = global_position.clamp(Vector2(-MAX_POSITION + 15.0, -MAX_POSITION + 15.0), Vector2(MAX_POSITION - 15.0, MAX_POSITION - 15.0))
	
	
	if _prev_position != global_position:
		linear_velocity = Vector2.ZERO
	
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
	
	if Input.is_action_just_pressed('mouse_1') and (timer >= timer_wait_time):
		launch_rocked()
		#fire_rate_timer.start()
		timer = 0
	
	if linear_velocity != Vector2.ZERO:
		sprite.rotation = linear_velocity.angle() + deg_to_rad(90)
	
	timer += delta



func launch_rocked():
	var rocked_instantiate := rocked_scene.instantiate()
	add_child(rocked_instantiate)
	rocked_instantiate.global_position = marker_for_muzzle.global_position
	rocked_instantiate.set_direction((get_global_mouse_position() - marker_for_muzzle.global_position).normalized())

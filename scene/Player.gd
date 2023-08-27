extends KinematicBody2D

onready var sprite = $Playercom
onready var coyote_timer = $CoyoteTimer
onready var jump_request_timer = $JumpRequestTimer

const gravity = 600.0
const max_speed = 200.0
const jump_force = 300.0
const accel = max_speed / 0.5
const air_accel = max_speed / 0.1

# export var is_dead = false

var velocity = Vector2.ZERO
var is_jumping = false

func _physics_process(delta):
	var was_on_floor = is_on_floor()
	var snap = Vector2.ZERO if is_jumping else Vector2.DOWN * 16
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	if is_on_floor():
		is_jumping = false
	elif was_on_floor and not is_jumping:
		coyote_timer.start()

func _input(event):
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	
	if event.is_action_released("jump") and velocity.y < -jump_force / 2:
		velocity.y = -jump_force / 2
		

func _process(delta):
	velocity.y += gravity * delta
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var acc = accel if is_on_floor() else accel
	velocity.x = move_toward(velocity.x, direction * max_speed, acc * delta)
	
	
	var can_jump = is_on_floor() or coyote_timer.time_left > 0
	if can_jump and jump_request_timer.time_left > 0:
		velocity.y = -jump_force
		is_jumping = true
		jump_request_timer.stop()
		coyote_timer.stop()
	
	if direction > 0:
		sprite.flip_h = false
	if direction < 0:
		sprite.flip_h = true
	
	if position.y > 1800:
		pass

func _on_Area2D_body_entered(body):
	get_tree().reload_current_scene()

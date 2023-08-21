extends CharacterBody2D

signal fire(engaged: bool)

@export var MAX_SPEED = 300
@export var ACCELERATION = 1500
@export var FRICTION = 1200
@onready var axis = Vector2.ZERO

func _physics_process(delta):
	move(delta)
	
func get_input_axis():
	axis = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)
	
func move(delta):
	monitor_firing_command()
	axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	
	move_and_slide()

func monitor_firing_command():
	if Input.is_action_just_pressed('fire'):
		emit_signal('fire', true)
	elif Input.is_action_just_released('fire'):
		emit_signal('fire', false)

class_name PlayerMovementController2D
extends Node

@export var MAX_SPEED: int = 300
@export var ACCELERATION: int = 1500
@export var FRICTION: int = 1200

var axis := Vector2.ZERO
var vel := Vector2.ZERO

signal apply_movement(movement: Vector2)

func _get_input_axis():
	axis = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func _apply_friction(amount):
	if vel.length() > amount:
		vel -= vel.normalized() * amount
	else:
		vel = Vector2.ZERO
		
func _apply_movement(accel):
	vel += accel
	vel = vel.limit_length(MAX_SPEED)

func _physics_process(delta):
	axis = _get_input_axis()
	if axis == Vector2.ZERO:
		_apply_friction(FRICTION * delta)
	else:
		_apply_movement(axis * ACCELERATION * delta)
	emit_signal("apply_movement", vel)

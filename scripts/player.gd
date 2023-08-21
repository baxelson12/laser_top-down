extends CharacterBody2D

signal fire(engaged: bool)

@export var MAX_SPEED = 300
@export var ACCELERATION = 1500
@export var FRICTION = 1200

@onready var MOVEMENT_CONTROLLER: PlayerMovementController2D = $PlayerMovementController2D

signal spawned(position: Vector2)
signal died(position: Vector2, xp: int)

func _ready():
	MOVEMENT_CONTROLLER.MAX_SPEED = MAX_SPEED
	MOVEMENT_CONTROLLER.ACCELERATION = ACCELERATION
	MOVEMENT_CONTROLLER.FRICTION = FRICTION

func monitor_firing_command():
	if Input.is_action_just_pressed('fire'):
		emit_signal('fire', true)
	elif Input.is_action_just_released('fire'):
		emit_signal('fire', false)

func _physics_process(delta):
	monitor_firing_command()

func _on_player_movement_controller_2d_apply_movement(movement):
	velocity = movement
	move_and_slide()

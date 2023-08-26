extends CharacterBody2D

signal fire(engaged: bool)

@export var MAX_SPEED: int = 300
@export var ACCELERATION: int = 1500
@export var FRICTION: int = 1200
@export var STARTING_HEALTH: float = 100

@onready var MOVEMENT_CONTROLLER: PlayerMovementController2D = $PlayerMovementController2D
@onready var ANIMATION_PLAYER: AnimationPlayer = $Sprite2D/AnimationPlayer

var current_health: float

signal spawned(position: Vector2)
signal died(position: Vector2, xp: int)
signal health_update(next_health: float)

func _ready():
	current_health = STARTING_HEALTH
	MOVEMENT_CONTROLLER.MAX_SPEED = MAX_SPEED
	MOVEMENT_CONTROLLER.ACCELERATION = ACCELERATION
	MOVEMENT_CONTROLLER.FRICTION = FRICTION
	emit_signal("spawned", global_position)

func _monitor_firing_command():
	if Input.is_action_just_pressed('fire'):
		emit_signal('fire', true)
	elif Input.is_action_just_released('fire'):
		emit_signal('fire', false)

func on_hit(damage: float):
	current_health -= damage
	emit_signal("health_update", clamp(0, 100, current_health))
	ANIMATION_PLAYER.play("damage_flash")

func kill() -> void:
	$DeathParticles.emitting = true
	MOVEMENT_CONTROLLER.MAX_SPEED = 0
	await get_tree().create_timer(0.4).timeout
	emit_signal("died", global_position, 0)
	queue_free()

func _physics_process(delta):
	if current_health <= 0: kill()
	_monitor_firing_command()

func _on_player_movement_controller_2d_apply_movement(movement):
	velocity = movement
	move_and_slide()

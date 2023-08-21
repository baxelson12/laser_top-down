extends CharacterBody2D

@export var MAX_HEALTH: float
@export var SPEED: float
@export var PLAYER: CharacterBody2D
@export var DAMAGE: float
@export var XP_VALUE: int

@onready var NAV_AGENT: NavigationAgent2D = $Pathfinding/NavigationAgent2D

signal spawned(position: Vector2)
signal died(position: Vector2, xp: int)

var health: float

func _ready():
	health = MAX_HEALTH
	NAV_AGENT.max_speed = SPEED
	_make_path()
	emit_signal("spawned", global_position)

func _make_path() -> void:
	NAV_AGENT.target_position = PLAYER.global_position

func on_hit(damage: float):
	health -= damage

func kill() -> void:
	$DeathParticles.emitting = true
	NAV_AGENT.max_speed = 0
	await get_tree().create_timer(0.4).timeout
	emit_signal("died", global_position, XP_VALUE)
	queue_free()

func _physics_process(delta: float) -> void:
	if health <= 0: kill()
	if NAV_AGENT.is_navigation_finished(): return
	
	var dir = to_local(NAV_AGENT.get_next_path_position()).normalized()
	var intended_velocity = dir * SPEED
	NAV_AGENT.set_velocity(intended_velocity)
	

func _on_timer_timeout():
	_make_path()

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

extends CharacterBody2D

@export var PLAYER: CharacterBody2D
@export var BATTERY_DECAY_RATE: float
@export var TARGET_RANGE_RADIUS: float

@onready var TARGET_RANGE: Area2D = $TargetRange
@onready var LASERS_NODE: Node2D = $Lasers
@onready var BATTERY_BAR: TextureProgressBar = $BatteryBar

var firing_engaged: bool = false
var is_firing: bool = false
var current_target_position: Vector2
var battery: float = 100.0

var _laser_scene := preload("res://scenes/laser.tscn")
var _instance: Node

func _on_fire(engaged: bool):
	firing_engaged = engaged

func _ready():
	PLAYER.connect('fire', _on_fire)

func _point_to_target(target: Vector2) -> void:
	var global_direction = target - global_position
	var angle = atan2(global_direction.y, global_direction.x)
	global_rotation = angle

func _fire() -> void:
	_instance = _laser_scene.instantiate()
	LASERS_NODE.add_child(_instance)
	_instance.is_casting = true

func _ceasefire() -> void:
	if not _instance: return
	_instance.is_casting = false
	_instance.queue_free()
	_instance = null

func _process(delta):
	if firing_engaged:
		var sorted_bodies = TARGET_RANGE.get_sorted_bodies()
		if sorted_bodies.size() == 0:
			_ceasefire()
			is_firing = false
			return
			
		_point_to_target(sorted_bodies[0].global_position)
		if not is_firing:
			_fire()
			is_firing = true
		battery -= BATTERY_DECAY_RATE * delta
	else:
		_ceasefire()
		battery += BATTERY_DECAY_RATE * delta
		is_firing = false
		firing_engaged = false
	
	battery = clamp(battery, 0, 100)
	BATTERY_BAR.update_remaining_power(battery)	
	if battery <= 0:
		_ceasefire()
		is_firing = false
		firing_engaged = false

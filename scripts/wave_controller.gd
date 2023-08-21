extends Node2D

@export_category("Initial Configuration")
@export_dir var ENEMY_SCENES_DIR: String
@export var STARTING_SPAWN_AMOUNT: int

@export_category("Wave Configuration")
@export var SPAWN_DELAY_TIME: float
@export var WAVE_DELAY_TIME: float
@export var SPAWN_AMOUNT_MULTIPLIER: float

@export_category("Enemy Multipliers")
@export var ENEMY_DAMAGE_MULTIPLIER: float
@export var ENEMY_HEALTH_MULTIPLIER: float

@onready var SpawnDelay = $SpawnDelay
@onready var WaveDelay = $WaveDelay
@onready var LivingEnemies = $LivingEnemies

var enemies: Array[PackedScene] = []
var spawn_points: Array[Marker2D] = []
var current_wave: int = 0
var current_spawn_amount: int = 0
var current_spawn_max: int
var current_enemy_damage_multiplier: float
var current_enemy_health_multiplier: float


func _create_enemies_array(enemy_dir: String) -> Array[PackedScene]:
	var arr: Array[PackedScene] = []
	var dir = DirAccess.open(enemy_dir)
	assert(dir, "Failed to load enemies directory (Looking in {0})".format([enemy_dir], "{_}"))
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var path = "{0}/{1}".format([enemy_dir, file_name], "{_}")
			arr.append(load(path))
		file_name = dir.get_next()
	
	return arr

func _create_spawn_points_array() -> Array[Marker2D]:
	var arr: Array[Marker2D] = []
	for child in get_node("SpawnPoints").get_children():
		if child is Marker2D: arr.append(child)
	return arr

func _start_wave() -> void:
	current_wave += 1
	@warning_ignore("narrowing_conversion")
	current_spawn_max *= SPAWN_AMOUNT_MULTIPLIER
	current_spawn_amount = 0
	WaveDelay.stop()
	SpawnDelay.start()
	print("Wave {0} started".format([current_wave], "{_}"))

func _spawn_enemy() -> void:
	var enemy = enemies[randi() % enemies.size()]
	var spawn_pos = spawn_points[randi() % spawn_points.size()].global_position
	var instance = enemy.instantiate()
	instance.PLAYER = get_tree().get_nodes_in_group("player")[0]
	LivingEnemies.add_child(instance)
	instance.global_position = spawn_pos
	instance.MAX_HEALTH *= ENEMY_HEALTH_MULTIPLIER
	instance.DAMAGE *= ENEMY_DAMAGE_MULTIPLIER
	current_spawn_amount += 1
	if current_spawn_amount >= current_spawn_max:
		print("End of wave spawning")
		SpawnDelay.stop()
		WaveDelay.start()
	

func _ready() -> void:
	assert(has_node("SpawnPoints"), "To use this scene, a SpawnPoints node must be added as a child with Marker2D's spawn positions")
	SpawnDelay.wait_time = SPAWN_DELAY_TIME
	WaveDelay.wait_time = WAVE_DELAY_TIME
	enemies = _create_enemies_array(ENEMY_SCENES_DIR)
	spawn_points = _create_spawn_points_array()
	current_spawn_max = STARTING_SPAWN_AMOUNT
	current_enemy_damage_multiplier = ENEMY_DAMAGE_MULTIPLIER
	current_enemy_health_multiplier = ENEMY_HEALTH_MULTIPLIER
	randomize()
	
	_start_wave()
	

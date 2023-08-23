extends Node

@export var WAVE_CONTROLLER: Node2D
@export var ACTIVE_CAMERA: Camera2D

var PAUSE_SCENE: PackedScene = preload("res://UI/pause_screen.tscn")
var pause_node: Node = null

func _ready():
	get_tree().paused = false

func _on_player_died(position, xp):
	WAVE_CONTROLLER.stop_all()
	get_tree().change_scene_to_file("res://UI/game_over_screen.tscn")

func _process(delta):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		print("Pausing...")
		var pause = PAUSE_SCENE.instantiate()
		ACTIVE_CAMERA.add_child(pause)
		pause_node = pause
		get_tree().paused = true
		print(get_tree().paused)
		return
	if Input.is_action_just_pressed("pause") and get_tree().paused:
		pause_node.queue_free()
		pause_node = null
		get_tree().paused = false
		print("Unpause ", get_tree().paused)
		return

extends Node

@export var WAVE_CONTROLLER: Node2D


func _on_player_died(position, xp):
	WAVE_CONTROLLER.stop_all()
	get_tree().change_scene_to_file("res://UI/game_over_screen.tscn")

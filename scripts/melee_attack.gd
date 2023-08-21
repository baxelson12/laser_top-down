extends Area2D

@export var ATTACK_VALUE: float

var attacking: bool = false
var player: CharacterBody2D

func _process(delta):
	if !player: return
	player.on_hit(ATTACK_VALUE)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		attacking = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		attacking = false

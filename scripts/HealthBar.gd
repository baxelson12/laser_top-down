extends Panel

@onready var HEALTH_PROGRESS = $PanelContainer/MarginContainer/HBoxContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_first_node_in_group("player").connect("health_update", _on_health_updated)

func _on_health_updated(next_health: float):
	HEALTH_PROGRESS.value = next_health


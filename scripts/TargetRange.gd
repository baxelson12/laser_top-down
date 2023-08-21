extends Area2D

var bodies: Array[Area2D] = []

func _on_area_entered(body: Area2D):
	bodies.append(body)

func _on_area_exited(body: Area2D):
	bodies.erase(body)

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _compare_bodies_by_distance(a: Area2D, b: Area2D):
	var parent = get_parent()
	var distance_a = a.global_position.distance_to(parent.global_position)
	var distance_b = b.global_position.distance_to(parent.global_position)
	return distance_a < distance_b

func sort_bodies_by_distance():
	bodies.sort_custom(_compare_bodies_by_distance)

func get_sorted_bodies() -> Array[Area2D]:
	sort_bodies_by_distance()
	return bodies

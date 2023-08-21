extends Node2D

@export var ROTATION_SPEED: float
@export var ORBITAL_RADIUS: float

#var last_parent_global_position: Vector2 = Vector2()
#var last_child_global_position: Vector2 = Vector2()
#var target_global_position: Vector2 = Vector2()
#var angle: float = 0.0
#var tracking: bool = false
#var reacting: bool = false

func _ready():
	assert(get_child_count() == 1, "Orbiter must have one child!")
	get_child(0).position = Vector2(ORBITAL_RADIUS, 0)

func _process(delta):
	var rotation_degrees = rad_to_deg(rotation) + ROTATION_SPEED * delta
	rotation_degrees = fmod(rotation_degrees, 360)
	rotation = deg_to_rad(rotation_degrees)

# TODO: Improve tracking concept
# two states, tracking or orbiting
# watch for parent moving, if it's moving start the delay timer
# if the delay timer is up, start lerping towards the current parent position
# if parent stops moving, resume orbiting

#func _process(delta):
#	angle += ROTATION_SPEED * delta
#	var parent_movement = PARENT.global_position - last_parent_global_position
#	var radian_angle = deg_to_rad(angle)
#	var next_vector = Vector2(
#		PARENT.global_position.x + ORBITAL_RADIUS * cos(radian_angle),
#		PARENT.global_position.y + ORBITAL_RADIUS * sin(radian_angle)
#	)
	
#	if parent_movement.length() > 0 and reacting and not tracking:
#		print("Waiting")
#		global_position = last_child_global_position
#		return
#	if parent_movement.length() > 0 and not (tracking or reacting):
#		print("Reacting")
#		reacting = true
#		last_child_global_position = global_position
#		TIMER.start()
#		return
#	if parent_movement.length() > 0 and tracking:
#		print("Tracking")
#		target_global_position = next_vector
#		global_position = global_position.lerp(target_global_position, delta / LAG_TIME)
#	if parent_movement.length() == 0:
#		tracking = false
#		global_position = next_vector
		
#	last_parent_global_position = PARENT.global_position

#func _on_lag_timer_timeout():
#	reacting = false
#	tracking = true
#	TIMER.stop()

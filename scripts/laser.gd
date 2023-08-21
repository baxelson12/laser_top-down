extends RayCast2D

@export var LASER_WIDTH: float
@export var TWEEN_APPEAR_TIME: float
@export var TWEEN_DISAPPEAR_TIME: float
@export var DAMAGE: float

var is_casting := false :
	set (value):
		is_casting = value
		$CastingParticles.emitting = is_casting
		$BeamParticles.emitting = is_casting
		if is_casting:
			appear()
		else:
			$CollisionParticles.emitting = false
			disappear()

		set_physics_process(is_casting)
	get:
		return is_casting

func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	$Line2D.width = 0.0

func _physics_process(delta: float) -> void:
	var cast_point := target_position
	force_raycast_update()
	
	$CollisionParticles.emitting = is_colliding()
	
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("enemies"): collider.on_hit(DAMAGE)
		
		cast_point = to_local(get_collision_point())
		$CollisionParticles.global_rotation = get_collision_normal().angle()
		$CollisionParticles.position = cast_point
		
	$Line2D.points[1] = cast_point
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.set_emission_rect_extents(Vector2(cast_point.length() * 0.5, 0))

func appear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", LASER_WIDTH, TWEEN_APPEAR_TIME).from(0.0)


func disappear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, TWEEN_DISAPPEAR_TIME).from(LASER_WIDTH)


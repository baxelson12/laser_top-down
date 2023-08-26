extends Camera2D

@export var TILEMAP: TileMap

# DEV: Ensure map starts at (0,0)
func _ready():
	var world_size_px = TILEMAP.get_used_rect().size * TILEMAP.cell_quadrant_size
	limit_top = 0
	limit_left = 0
	limit_right = world_size_px.x
	limit_bottom = world_size_px.y

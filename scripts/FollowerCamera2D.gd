extends Camera2D

@export var TILEMAP: TileMap

func _ready():
	var mapRect = TILEMAP.get_used_rect()
	var tileSize = TILEMAP.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_top = 0
	limit_left = 0
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y

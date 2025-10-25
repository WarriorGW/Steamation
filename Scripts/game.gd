extends Node2D

@onready var water_layer: TileMapLayer = $Tilemaps/WaterLayer
@onready var grass_cliff_water: TileMapDual = $Tilemaps/Grass_Cliff_Water
@onready var dirt_grass: TileMapDual = $Tilemaps/Dirt_Grass

const WATER_COLLISION_TILE = Vector2i(0, 0)
const WATER_WALKABLE_TILE = Vector2i(1, 0)

const MAP_WIDTH = 200
const MAP_HEIGHT = 200

func _ready():
	#fill_water()
	pass

func fill_water():
	@warning_ignore("integer_division")
	var offset_x = int(MAP_WIDTH / 2)
	@warning_ignore("integer_division")
	var offset_y = int(MAP_HEIGHT / 2)

	for x in range(-offset_x, offset_x):
		for y in range(-offset_y, offset_y):
			var cell = Vector2i(x, y)
			
			#var ground_id = ground_map.get_cell_source_id(cell)
			#if ground_id == -1:
				#print("❌ Tile vacío en:", cell)

			var has_ground := (
				grass_cliff_water.get_cell_source_id(cell) != -1 or
				dirt_grass.get_cell_source_id(cell) != -1
			)

			if has_ground:
				water_layer.set_cell(cell, 0, WATER_WALKABLE_TILE)
			else:
				water_layer.set_cell(cell, 0, WATER_COLLISION_TILE)

extends Node2D

@onready var water_layer: TileMapLayer = $WaterLayer
@onready var grass_cliff_water: TileMapDual = $Grass_Cliff_Water
@onready var dirt_grass: TileMapDual = $Dirt_Grass

const WATER_COLLISION_TILE = Vector2i(0, 0)
const WATER_WALKABLE_TILE = Vector2i(1, 0)

const MAP_WIDTH = 200
const MAP_HEIGHT = 200

signal tile_changed(cell: Vector2i, layer: TileMapDual)

func _ready():
	fill_water()
	
func place_tile(cell: Vector2i, layer: TileMapDual, terrain: int) -> bool:
	if not is_instance_valid(layer) or layer._display == null or layer._display.terrain.terrains == null:
		print("ERROR: TileMapDual _display o terrains no está inicializado")
		return false
	
	# Aquí puedes poner lógica de recursos si quieres
	#if not has_enough_coins(5):
	#	return false

	layer.draw_cell(cell, terrain)
	update_water_at(cell)
	emit_signal("tile_changed", cell, layer)
	return true

# Función genérica para remover un tile en un TileMapDual
func remove_tile(cell: Vector2i, layer: TileMapDual) -> void:
	if not is_instance_valid(layer) or layer._display == null or layer._display.terrain.terrains == null:
		print("ERROR: TileMapDual _display o terrains no está inicializado")
		return
	layer.draw_cell(cell, -1) # -1 = borrar completamente
	update_water_at(cell)
	if layer == grass_cliff_water:
		_remove_floating_dirt(cell)
	emit_signal("tile_changed", cell, layer)

func fill_water():
	@warning_ignore("integer_division")
	var offset_x = int(MAP_WIDTH / 2)
	@warning_ignore("integer_division")
	var offset_y = int(MAP_HEIGHT / 2)

	for x in range(-offset_x, offset_x):
		for y in range(-offset_y, offset_y):
			var cell = Vector2i(x, y)
			var has_ground := (
				grass_cliff_water.get_cell_source_id(cell) != -1 or
				dirt_grass.get_cell_source_id(cell) != -1
			)
			if has_ground:
				water_layer.set_cell(cell, 0, WATER_WALKABLE_TILE)
			else:
				water_layer.set_cell(cell, 0, WATER_COLLISION_TILE)

func update_water_at(cell: Vector2i) -> void:
	var has_ground := (
		grass_cliff_water.get_cell_source_id(cell) != -1 or
		dirt_grass.get_cell_source_id(cell) != -1
	)

	if has_ground:
		water_layer.set_cell(cell, 0, WATER_WALKABLE_TILE)
	else:
		water_layer.set_cell(cell, 0, WATER_COLLISION_TILE)

func _remove_floating_dirt(cell: Vector2i) -> void:
	# Si la celda tiene dirt encima y ya no hay grass debajo, eliminar la dirt
	var has_grass := grass_cliff_water.get_cell_source_id(cell) != -1
	if not has_grass:
		if dirt_grass.get_cell_source_id(cell) != -1:
			#print("Removing floating dirt at: ", cell)
			dirt_grass.draw_cell(cell, -1)

func is_machine_at(cell: Vector2i) -> bool:
	#if machines_layer == null:
		#return false
	#return machines_layer.get_cell_source_id(cell) != -1
	if cell:
		return false # Solo para quitar un advertencia
	return false

func get_top_tile(cell: Vector2i) -> TileMapDual:
	# Primero checa dirt, luego grass
	if dirt_grass.get_cell_source_id(cell) != -1:
		return dirt_grass
	elif grass_cliff_water.get_cell_source_id(cell) != -1:
		return grass_cliff_water
	return null

func get_tile_info(cell: Vector2i, layer: TileMapDual) -> Dictionary:
	if layer == null:
		return {}
	var sid = layer.get_cell_source_id(cell)
	if sid == -1:
		return {}
	var tile_info_array = layer._display.terrain.terrains.get(sid, [])
	if tile_info_array.size() == 0:
		return {}
	return tile_info_array[0]  # devuelve primer tile info como Dictionary

func can_place_dirt(cell: Vector2i) -> bool:
	return grass_cliff_water.get_cell_source_id(cell) != -1

func can_remove_tile(cell: Vector2i, layer: TileMapDual) -> bool:
	if layer == grass_cliff_water || cell: # || cell solo para quitar advertencia
		pass
		#return not is_machine_at(cell)
	return true

# Llama a todos los listeners cuando un tile cambia
func notify_tile_changed(cell: Vector2i, layer: TileMapDual) -> void:
	emit_signal("tile_changed", cell, layer)

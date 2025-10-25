extends PanelContainer

@onready var build_grass_cliff_water: TileMapDual = $"../../../Tilemaps/Grass_Cliff_Water"
@onready var terrain_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/TerrainBtn
@onready var tilemap: TileMapLayer = $"../../../Tilemaps/WaterLayer"

var build_mode := true
var left_pressed := false
var right_pressed := false

func _ready() -> void:
	# Conectar el botón para alternar el modo build
	terrain_btn.pressed.connect(_on_terrain_btn_pressed)
	print(build_grass_cliff_water._display.terrain.terrains)

func _process(_delta: float) -> void:
	if not build_mode:
		return
	
	var cell = build_grass_cliff_water.local_to_map(tilemap.get_local_mouse_position())
	
	if left_pressed:
		_place_tile(cell)
	elif right_pressed:
		_remove_tile(cell)

func _on_terrain_btn_pressed() -> void:
	build_mode = !build_mode
	print("Build mode:", build_mode)

func _input(event: InputEvent) -> void:
	if not build_mode:
		return

	if event is InputEventMouseButton:
		var cell = build_grass_cliff_water.local_to_map(tilemap.get_local_mouse_position())
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_pressed = event.pressed
			if left_pressed:
				_place_tile(cell)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_pressed = event.pressed
			if right_pressed:
				_remove_tile(cell)

func _place_tile(cell: Vector2i) -> void:
	var terrain_data = build_grass_cliff_water._display.terrain.terrains[1]
	print("+ Colocando tile en celda:", cell)
	if terrain_data.size() > 0:
		var tile_info: Dictionary = terrain_data[0]
		build_grass_cliff_water.set_cell(cell, tile_info.sid, tile_info.tile)
		build_grass_cliff_water.changed.emit()

func _remove_tile(cell: Vector2i) -> void:
	print("- Borrando tile en celda:", cell)
	build_grass_cliff_water.draw_cell(cell, -1)

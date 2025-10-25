extends PanelContainer

@onready var build_grass_cliff_water: TileMapDual = $"../../../Tilemaps/Grass_Cliff_Water"
@onready var terrain_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/TerrainBtn

var build_mode := true

func _ready() -> void:
	# Conectar el botón para alternar el modo build
	terrain_btn.pressed.connect(_on_terrain_btn_pressed)

func _on_terrain_btn_pressed() -> void:
	build_mode = !build_mode
	print("Build mode:", build_mode)

func _input(event: InputEvent) -> void:
	if not build_mode:
		return

	if event is InputEventMouseButton and event.pressed:
		# Obtener la celda bajo el mouse
		var mouse_pos_global = get_global_mouse_position()      # Posición en el mundo
		var mouse_pos_local = build_grass_cliff_water.to_local(mouse_pos_global)  # Convertir al espacio local del TileMap
		var cell = build_grass_cliff_water.local_to_map(mouse_pos_local)          # Obtener la celda correcta


		print("Mouse" + event.as_text())
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_place_tile(cell)
			MOUSE_BUTTON_RIGHT:
				_remove_tile(cell)

func _place_tile(cell: Vector2i) -> void:
	# Coloca la tile "grass_cliff" (ID 1)
	print("Dibujando", build_grass_cliff_water._display.terrain.terrains)

	var terrains_list: Array = build_grass_cliff_water._display.terrain.terrains.get(1, []) as Array
	if terrains_list.is_empty():
		print("No hay tile disponible para grass_cliff")
		return

	# Tomamos el primer tile del array
	var tile_to_use: Dictionary = terrains_list[0]
	var sid: int = tile_to_use.sid
	var tile: Vector2i = tile_to_use.tile

	build_grass_cliff_water.set_cell(cell, sid, tile)
	print("Tile colocada en ", cell)

func _remove_tile(cell: Vector2i) -> void:
	# Borra la tile usando draw_cell con -1
	build_grass_cliff_water.draw_cell(cell, -1)
	print("Tile eliminada en ", cell)

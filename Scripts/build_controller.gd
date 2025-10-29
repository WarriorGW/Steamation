extends Node

#@onready var terrain_btn: Button = $BuildingMenu/MarginContainer/HBoxContainer/VBoxContainer/TerrainBtn
var tilemaps: Node2D
var building_menu: PanelContainer

var build_mode := false
var left_pressed := false
var right_pressed := false
var selected_terrain := 1 
var current_layer: TileMapDual

func _ready() -> void:
	# Conectar el botón para alternar el modo build
	pass

func register_scene_references(scene_root: Node):
	tilemaps = scene_root.get_node("Tilemaps")
	building_menu = scene_root.get_node("CanvasLayer/UI/BuildingMenu")

	if building_menu:
		building_menu.build_selected.connect(_on_build_selected)
		var terrain_btn = building_menu.get_node("MarginContainer/HBoxContainer/VBoxContainer/TerrainBtn")
		if terrain_btn:
			terrain_btn.pressed.connect(_on_terrain_btn_pressed)
		print("✅ BuildController listo")
	else:
		push_warning("⚠️ No se encontró el BuildingMenu")

func _on_build_selected(item_name: String):
	match item_name:
		"grass_cliff":
			selected_terrain = 1
			current_layer = tilemaps.grass_cliff_water
		"dirt_grass":
			selected_terrain = 1
			current_layer = tilemaps.dirt_grass
		"none":
			selected_terrain = 1
		_:
			selected_terrain = 1

func _process(_delta: float) -> void:
	if not build_mode:
		return
	
	var cell = tilemaps.grass_cliff_water.local_to_map(tilemaps.grass_cliff_water.get_local_mouse_position())
	
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
		var cell = tilemaps.grass_cliff_water.local_to_map(tilemaps.grass_cliff_water.get_local_mouse_position())

		if event.button_index == MOUSE_BUTTON_LEFT:
			left_pressed = event.pressed
			if left_pressed:
				_place_tile(cell)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_pressed = event.pressed
			if right_pressed:
				_remove_tile(cell)

func _place_tile(cell: Vector2i) -> void:
	if tilemaps != null:
		tilemaps.place_tile(cell, current_layer, selected_terrain)

func _remove_tile(cell: Vector2i) -> void:
	if tilemaps != null:
		tilemaps.remove_tile(cell, current_layer)

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("quick_action_1"):
		#selected_terrain = 1
	#elif event.is_action_pressed("quick_action_2"):
		#selected_terrain = 2
	#elif event.is_action_pressed("quick_action_0"):
		#selected_terrain = 0

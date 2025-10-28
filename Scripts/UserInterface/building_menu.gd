extends PanelContainer

@onready var terrain_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/TerrainBtn
@onready var tilemaps: Node2D = $"../../../Tilemaps"

var build_mode := true
var left_pressed := false
var right_pressed := false
var selected_terrain := 1 # 1 = Grass, 2 = Dirt, 0 = background/none

func _ready() -> void:
	# Conectar el botón para alternar el modo build
	terrain_btn.pressed.connect(_on_terrain_btn_pressed)

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
	#print("Build mode:", build_mode)

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
		tilemaps.place_tile(cell, tilemaps.grass_cliff_water, selected_terrain)

func _remove_tile(cell: Vector2i) -> void:
	if tilemaps != null:
		tilemaps.remove_tile(cell, tilemaps.grass_cliff_water)

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("quick_action_1"):
		#selected_terrain = 1
	#elif event.is_action_pressed("quick_action_2"):
		#selected_terrain = 2
	#elif event.is_action_pressed("quick_action_0"):
		#selected_terrain = 0

extends Node2D

@onready var highlight: ColorRect = $Highlight
@onready var grass_cliff_water: TileMapDual = $"../Tilemaps/Grass_Cliff_Water"

var tile_size: Vector2 = Vector2(16,16) # tamaño lógico de celda

func _process(_delta):
	# posición del mouse en el mundo
	var mouse_pos = get_global_mouse_position()
	
	# calcular celda en la grilla
	var cell = Vector2(floor(mouse_pos.x / tile_size.x), floor(mouse_pos.y / tile_size.y))
	
	# calcular posición exacta en el mundo
	var cell_pos = cell * tile_size
	
	# asignar posición y tamaño al highlight
	highlight.position = cell_pos
	highlight.size = tile_size
	highlight.color = Color(1,1,0,0.4)

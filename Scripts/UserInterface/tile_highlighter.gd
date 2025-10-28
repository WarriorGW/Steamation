extends Node2D

@onready var highlight: ColorRect = $Highlight
@onready var grass_cliff_water: TileMapDual = $"../Tilemaps/Grass_Cliff_Water"

var tile_size: Vector2 = Vector2(16,16) # tamaño lógico de celda
var current_cell := Vector2.ZERO
var is_valid_tile := false

signal tile_hovered(cell: Vector2, is_valid: bool)

var placer: Node = null

func _ready() -> void:
	highlight.size = tile_size
	highlight.color = Color(1, 1, 0, 0.4) # color por defecto (amarillo)
	# Busca automáticamente un placer si está en la misma escena
	placer = get_parent().get_node_or_null("Placer")

func _process(_delta):
	# posición del mouse en el mundo
	var mouse_pos = get_global_mouse_position()
	
	# calcular celda en la grilla
	var cell = Vector2(floor(mouse_pos.x / tile_size.x), floor(mouse_pos.y / tile_size.y))
	
	# calcular posición exacta en el mundo
	#var cell_pos = cell * tile_size
	if cell != current_cell:
		current_cell = cell
		update_highlight()
	
	# asignar posición y tamaño al highlight
	#highlight.position = cell_pos
	#highlight.size = tile_size
	#highlight.color = Color(1,1,0,0.4)

func update_highlight():
	var cell_pos = current_cell * tile_size
	highlight.position = cell_pos

	# Si hay placer, le pedimos validar
	if placer and placer.has_method("can_place_at"):
		is_valid_tile = placer.can_place_at(current_cell)
	else:
		is_valid_tile = true # si no hay placer, asumimos que sí se puede

	# Cambiar color según validez
	highlight.color = Color(0,1,0,0.3) if is_valid_tile else Color(1,0,0,0.3)

	# Emitir señal (por si otros nodos quieren reaccionar)
	emit_signal("tile_hovered", current_cell, is_valid_tile)

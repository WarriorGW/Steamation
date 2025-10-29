extends PanelContainer

signal build_selected(item_name: String)
signal build_cancelled

@onready var terrain_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/TerrainBtn
@onready var machines_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/MachinesBtn
@onready var decorations_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/DecorationsBtn
@onready var grid: GridContainer = $MarginContainer/HBoxContainer/ScrollContainer/GridContainer

var current_category: String = ""

func _ready():
	# Conectamos los tabs
	terrain_btn.pressed.connect(_on_tab_pressed.bind("terrain"))
	machines_btn.pressed.connect(_on_tab_pressed.bind("machines"))
	decorations_btn.pressed.connect(_on_tab_pressed.bind("decorations"))
	
	hide() # Ocultamos el menú por defecto

func open():
	show()
	_on_tab_pressed("terrain") # Mostrar la primera categoría por defecto

func close():
	hide()

func _on_tab_pressed(category: String):
	current_category = category
	_update_grid(category)

func _update_grid(category: String):
	# Limpiamos los botones previos
	for child in grid.get_children():
		child.queue_free()
	
	var items = _get_items_for_category(category)
	
	for item_name in items:
		var btn = Button.new()
		btn.text = item_name.capitalize()
		btn.custom_minimum_size = Vector2(40, 40)
		btn.pressed.connect(_on_item_pressed.bind(item_name))
		grid.add_child(btn)

func _on_item_pressed(item_name: String):
	emit_signal("build_selected", item_name)
	#hide()

# Aquí defines lo que aparece en cada pestaña
func _get_items_for_category(category: String) -> Array:
	match category:
		"terrain":
			return ["grass_cliff", "dirt_grass"]
		"machines":
			return ["generator", "pump", "crusher"]
		"decorations":
			return ["tree", "lamp", "bench"]
		_:
			return []

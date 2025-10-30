extends PanelContainer

@onready var level_buttons := [
	$MarginContainer/HBoxContainer/VBoxContainer/Level1Btn,
	$MarginContainer/HBoxContainer/VBoxContainer/Level2Btn,
	$MarginContainer/HBoxContainer/VBoxContainer/Level3Btn,
	$MarginContainer/HBoxContainer/VBoxContainer/Level4Btn,
	$MarginContainer/HBoxContainer/VBoxContainer/Level5Btn
]

@onready var description_label: RichTextLabel = $MarginContainer/HBoxContainer/ColorRect/LevelDescriptionLabel
@onready var cost_label: Label = $MarginContainer/HBoxContainer/ColorRect/VBoxContainer/CostLabel
@onready var level_up_btn: Button = $MarginContainer/HBoxContainer/ColorRect/VBoxContainer/HBoxContainer/LevelUpBtn

var selected_level := 0
var unlocked_levels := [true, false, false, false, false]  # Solo el nivel 1 visible
var purchased_levels := [false, false, false, false, false] # Ninguno comprado al inicio

var level_data = [
	{"name": "Level 1", "cost": 500, "desc": "Unlocks the shop quick access."},
	{"name": "Level 2", "cost": 1000, "desc": "Unlocks dirt tile on building menu."},
	{"name": "Level 3", "cost": 2000, "desc": "Unlocks more machines."},
	{"name": "Level 4", "cost": 5000, "desc": "Unlocks zoom control."},
	{"name": "Level 5", "cost": 10000, "desc": "Unlocks all the machines."}
]

func _ready() -> void:
	for i in range(level_buttons.size()):
		level_buttons[i].pressed.connect(_on_level_button_pressed.bind(i))

	level_up_btn.pressed.connect(_on_level_up_pressed)
	_update_ui()

func _on_level_button_pressed(level_index: int) -> void:
	selected_level = level_index
	_update_ui()

func _update_ui():
	var data = level_data[selected_level]
	description_label.text = data.desc
	cost_label.text = "Costo: " + str(data.cost) + " monedas"

	# Actualizar visualmente los botones
	for i in range(level_buttons.size()):
		var btn = level_buttons[i]
		btn.text = level_data[i].name

		if not unlocked_levels[i]:
			btn.disabled = true
			btn.modulate = Color(0.4, 0.4, 0.4) # gris: bloqueado
		else:
			btn.disabled = false
			if purchased_levels[i]:
				btn.modulate = Color(0.2, 1, 0.2) # verde: comprado
			elif i == selected_level:
				btn.modulate = Color(1, 1, 0.3) # amarillo: seleccionado
			else:
				btn.modulate = Color(1, 1, 1) # normal

	# Configurar el botón de compra
	if purchased_levels[selected_level]:
		level_up_btn.disabled = true
		level_up_btn.text = "Comprado ✅"
	elif selected_level > 0 and not purchased_levels[selected_level - 1]:
		level_up_btn.disabled = true
		level_up_btn.text = "Bloqueado 🔒"
	else:
		level_up_btn.disabled = false
		level_up_btn.text = "Comprar"

func _on_level_up_pressed() -> void:
	var data = level_data[selected_level]
	var cost = data.cost

	if PlayerData.money < cost:
		show_error_feedback(level_up_btn)
		print("❌ No tienes suficiente dinero")
		return

	# Verificar que el anterior esté comprado
	if selected_level > 0 and not purchased_levels[selected_level - 1]:
		print("❌ Debes comprar el nivel anterior primero")
		return

	# Compra exitosa
	PlayerData.remove_money(cost)
	purchased_levels[selected_level] = true
	print("✅ Compraste " + data.name)

	# Desbloquear el siguiente si existe
	if selected_level + 1 < unlocked_levels.size():
		unlocked_levels[selected_level + 1] = true

	_update_ui()

func show_error_feedback(button: Button):
	if button.has_meta("error_tween"):
		var prev_tween = button.get_meta("error_tween")
		if is_instance_valid(prev_tween):
			prev_tween.kill()
			#button.scale = Vector2.ONE
			button.position = Vector2.ZERO
			button.modulate = Color.WHITE

	var tween = create_tween()
	button.set_meta("error_tween", tween)

	var original_color = button.modulate
	var original_pos = button.position

	# Efecto: color + pequeño “temblor” (rotación + escala)
	tween.parallel().tween_property(button, "modulate", Color(1, 0.3, 0.3), 0.1)
	tween.parallel().tween_property(button, "position:x", original_pos.x + 5, 0.05)
	tween.tween_property(button, "position:x", original_pos.x - 5, 0.05)
	tween.tween_property(button, "position:x", original_pos.x, 0.05)
	tween.tween_property(button, "modulate", original_color, 0.2)

	tween.connect("finished", func():
		button.modulate = original_color
		button.position = original_pos
		if button.has_meta("error_tween"):
			button.remove_meta("error_tween")
	)

extends PanelContainer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		print("Inventario de jugador")
		get_viewport().set_input_as_handled()

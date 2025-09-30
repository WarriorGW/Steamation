extends PanelContainer

@onready var building_menu: PanelContainer = $"."

func toggle_building_menu():
	building_menu.visible = !building_menu.visible

func _on_build_btn_pressed() -> void:
	toggle_building_menu()

func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_build"):
		toggle_building_menu()
		get_viewport().set_input_as_handled()

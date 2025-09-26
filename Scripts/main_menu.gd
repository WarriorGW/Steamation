extends PanelContainer

@onready var main_menu: PanelContainer = $"."

func toggle_main_menu():
	main_menu.visible = !main_menu.visible

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_menu"):
		toggle_main_menu()

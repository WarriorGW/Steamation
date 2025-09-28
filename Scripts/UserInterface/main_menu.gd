extends PanelContainer

@onready var main_menu: PanelContainer = $"."
@onready var continue_btn: Button = $MarginContainer/GridContainer/ContinueBtn

var paused := false

func toggle_main_menu():
	paused = !paused
	main_menu.visible = paused
	get_tree().paused = paused

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_menu"):
		toggle_main_menu()

func _on_continue_btn_pressed() -> void:
	toggle_main_menu()

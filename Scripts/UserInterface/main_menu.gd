extends PanelContainer

@onready var main_menu: PanelContainer = $"."
@onready var continue_btn: Button = $MarginContainer/GridContainer/ContinueBtn
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _ready() -> void:
	#main_menu.visible = false
	#print("Estado inicial:", main_menu.visible)
	pass

func toggle_main_menu():
	if main_menu.visible == false:
		animation_player.play("show_main_menu")
		get_tree().paused = true
	else:
		animation_player.play("hide_main_menu")
		get_tree().paused = false
	main_menu.visible = !main_menu.visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_menu"):
		toggle_main_menu()
		get_viewport().set_input_as_handled()

func _on_continue_btn_pressed() -> void:
	toggle_main_menu()

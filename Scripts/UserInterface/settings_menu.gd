extends PanelContainer

@onready var main_menu: PanelContainer = $"."
@onready var settings_menu: PanelContainer = $"../SettingsMenu"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func toggle():
	pass
	#if settings_menu.visible == false:
		#await animation_player.animation_finished
		#animation_player.play("show_settings_menu")
	#else:
		#await animation_player.animation_finished
		#animation_player.play("hide_settings_menu")

func _gui_input(event: InputEvent) -> void:
	#if event.is_action_pressed("toggle_menu"):
		#print("mamaguebo")
		#get_viewport().set_input_as_handled()
	pass

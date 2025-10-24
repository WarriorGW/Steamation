extends Control

# --- Referencias a menús ---
@onready var main_menu: PanelContainer = $MainMenu
@onready var settings_menu: PanelContainer = $SettingsMenu
@onready var building_menu: PanelContainer = $BuildingMenu

# --- Botones ---
@onready var continue_btn: Button = $MainMenu/MarginContainer/GridContainer/ContinueBtn
@onready var settings_btn: Button = $MainMenu/MarginContainer/GridContainer/SettingsBtn
@onready var save_quit_btn: Button = $MainMenu/MarginContainer/GridContainer/SaveQuitBtn
@onready var exit_settings_menu_btn: Button = $SettingsMenu/MarginContainer/VBoxContainer/ExitSettingsMenuBtn
#@onready var build_btn: Button = $BuildingMenu/MarginContainer/VBoxContainer/BuildBtn

# --- Animaciones ---
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# --- Estado del menu actual
var current_menu: String = ""

func _ready() -> void:
	# Conexión de botones
	exit_settings_menu_btn.pressed.connect(_on_exit_settings_menu_pressed)
	settings_btn.pressed.connect(_on_settings_btn_pressed)
	continue_btn.pressed.connect(_on_continue_btn_pressed)
	save_quit_btn.pressed.connect(_on_save_quit_btn_pressed)
	#build_btn.pressed.connect(_on_build_btn_pressed)

	# Ocultar todo al inicio
	main_menu.visible = false
	settings_menu.visible = false
	building_menu.visible = false

# =====================================
#   SISTEMA DE MENÚS
# =====================================

func toggle_main_menu() -> void:
	if main_menu.visible:
		animation_player.play("hide_main_menu")
		get_tree().paused = false
	else:
		animation_player.play("show_main_menu")
		get_tree().paused = true

func toggle_settings_menu() -> void:
	if settings_menu.visible:
		animation_player.play("hide_settings_menu")
	else:
		animation_player.play("show_settings_menu")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_menu"):
		_handle_menu_toggle()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("open_build"):
		_on_build_btn_pressed()

func _handle_menu_toggle() -> void:
	if settings_menu.visible:
		toggle_settings_menu()
		await animation_player.animation_finished
		toggle_main_menu()
	elif main_menu.visible:
		toggle_main_menu()
	else:
		toggle_main_menu()

func _on_continue_btn_pressed() -> void:
	toggle_main_menu()

func _on_settings_btn_pressed() -> void:
	if main_menu.visible:
		toggle_main_menu()
		await animation_player.animation_finished
	toggle_settings_menu()

func _on_save_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_exit_settings_menu_pressed() -> void:
	_handle_menu_toggle()

func _on_build_btn_pressed():
	building_menu.visible = !building_menu.visible

extends PanelContainer

# --- Sliders ---
@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/Volume/Sliders/MasterSliderBox/MasterSlider
@onready var music_slider: HSlider  = $MarginContainer/VBoxContainer/Volume/Sliders/MusicSliderBox/MusicSlider
@onready var sfx_slider: HSlider    = $MarginContainer/VBoxContainer/Volume/Sliders/SFXSliderBox/SFXSlider

# --- Labels ---
@onready var master_label: Label = $MarginContainer/VBoxContainer/Volume/Sliders/MasterSliderBox/MasterPercentage
@onready var music_label: Label  = $MarginContainer/VBoxContainer/Volume/Sliders/MusicSliderBox/MusicPercentage
@onready var sfx_label: Label    = $MarginContainer/VBoxContainer/Volume/Sliders/SFXSliderBox/SFXPercentage

func _ready():
	# Master
	var master_index = AudioServer.get_bus_index("Master")
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	master_slider.connect("value_changed", Callable(self, "_on_master_slider_changed"))
	_update_master_label(master_slider.value)
	
	# Music
	var music_index = AudioServer.get_bus_index("Music")
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))
	music_slider.connect("value_changed", Callable(self, "_on_music_slider_changed"))
	_update_music_label(music_slider.value)
	
	# SFX
	var sfx_index = AudioServer.get_bus_index("SFX")
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index))
	sfx_slider.connect("value_changed", Callable(self, "_on_sfx_slider_changed"))
	_update_sfx_label(sfx_slider.value)

# --- Callbacks de sliders ---
func _on_master_slider_changed(value: float) -> void:
	var db_value = linear_to_db(value)
	var master_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_index, db_value)
	_update_master_label(value)

func _on_music_slider_changed(value: float) -> void:
	var db_value = linear_to_db(value)
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, db_value)
	_update_music_label(value)

func _on_sfx_slider_changed(value: float) -> void:
	var db_value = linear_to_db(value)
	var sfx_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, db_value)
	_update_sfx_label(value)

# --- Funciones para actualizar labels ---
func _update_master_label(value: float) -> void:
	master_label.text = str(int(value * 100)) + "%"

func _update_music_label(value: float) -> void:
	music_label.text = str(int(value * 100)) + "%"

func _update_sfx_label(value: float) -> void:
	sfx_label.text = str(int(value * 100)) + "%"

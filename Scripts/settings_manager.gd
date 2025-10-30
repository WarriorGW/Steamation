extends Node

var master_volume := 1.0
var music_volume := 1.0
var sfx_volume := 1.0

func _ready():
	load_settings()
	apply_volumes()

func save_settings():
	var cfg = ConfigFile.new()
	cfg.set_value("audio", "master_volume", master_volume)
	cfg.set_value("audio", "music_volume", music_volume)
	cfg.set_value("audio", "sfx_volume", sfx_volume)
	cfg.save("user://settings.cfg")

func load_settings():
	var cfg = ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		master_volume = cfg.get_value("audio", "master_volume", 1.0)
		music_volume = cfg.get_value("audio", "music_volume", 1.0)
		sfx_volume = cfg.get_value("audio", "sfx_volume", 1.0)

func apply_volumes():
	var master_index = AudioServer.get_bus_index("Master")
	var music_index = AudioServer.get_bus_index("Music")
	var sfx_index = AudioServer.get_bus_index("SFX")

	AudioServer.set_bus_volume_db(master_index, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(music_index, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx_volume))

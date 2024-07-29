extends Node

var config  = ConfigFile.new()

const FILEPATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(FILEPATH):
		config.set_value("Audio", "Mute", false)
		config.set_value("Audio", "Master", 6)
		config.set_value("Audio", "Music", 6)
		config.set_value("Audio", "SFX", 6)
		
		config.set_value("Resolution", "WindowWidth", 1280)
		config.set_value("Resolution", "WindowHeight", 1024)
		
		config.set_value("Video Settings", "Fullscreen", false)

		config.save(FILEPATH)
	else:
		config.load(FILEPATH)

func save_audio_settings(key: String, value) -> void:
	config.set_value("Audio", key, value)
	config.save(FILEPATH)

func load_audio_settings() -> Dictionary:
	var audio = {}
	for key in config.get_section_keys("Audio"):
		audio[key] = config.get_value("Audio", key)
	return audio	


func save_video_settings(key: String, value) -> void:
	config.set_value("Video Settings", key, value)
	config.save(FILEPATH)

func load_video_settings() -> Dictionary:
	var video = {}
	for key in config.get_section_keys("Video Settings"):
		video[key] = config.get_value("Video Settings", key)
	return video

func save_resolution(key: String, value) -> void:
	config.set_value("Resolution", key, value)
	config.save(FILEPATH)
	
func load_resolution() ->Dictionary:
	var resolution = {}
	for key in config.get_section_keys("Resolution"):
		resolution[key] = config.get_value("Resolution", key)
	return resolution

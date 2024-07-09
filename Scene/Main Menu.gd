extends Node



func _ready() -> void:
	var audio_setting = ConfigFileHandler.load_audio_settings()
	AudioServer.set_bus_mute(0, audio_setting.get("Mute"))
	AudioServer.set_bus_volume_db(0, audio_setting.get("Master"))
	AudioServer.set_bus_volume_db(1, audio_setting.get("Music"))
	AudioServer.set_bus_volume_db(2, audio_setting.get("SFX"))
	var video_settings = ConfigFileHandler.load_video_settings()
	var resolution_settings = ConfigFileHandler.load_resolution()
	var res := Vector2i(resolution_settings.get("WindowWidth"),resolution_settings.get("WindowHeight"))
	DisplayServer.window_set_size(res)
	if video_settings.get("Fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#var size = DisplayServer.screen_get_size()
	#DisplayServer.window_set_size(size)
	#print(DisplayServer.window_get_size())
	#ProjectSettings.set_setting("display/window/size/window_height_override",size.y)
	#ProjectSettings.set_setting("display/window/size/window_width_override",size.x)
	
func _on_start_pressed() -> void:
	GameManager.setChange("res://Scene/level1.tscn")
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)

func _on_level_select_pressed() -> void:
	GameManager.setChange("res://Scene/Level Select.tscn")

func _on_settings_pressed() -> void:
	GameManager.setChange("res://Scene/Settings.tscn")

func _on_quit_pressed() -> void:
	GameManager.quitGame()

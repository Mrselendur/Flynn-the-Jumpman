extends Node

@onready var musicStream: AudioStream = preload("res://Free/Audio/Music/Intro Theme.mp3")

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	var audioSettings = ConfigFileHandler.load_audio_settings()
	AudioServer.set_bus_mute(0, audioSettings.get("Mute"))
	AudioServer.set_bus_volume_db(0, audioSettings.get("Master"))
	AudioServer.set_bus_volume_db(1, audioSettings.get("Music"))
	AudioServer.set_bus_volume_db(2, audioSettings.get("SFX"))
	var videoSettings = ConfigFileHandler.load_video_settings()
	var resolutionSettings = ConfigFileHandler.load_resolution()
	var res := Vector2i(resolutionSettings.get("WindowWidth"),resolutionSettings.get("WindowHeight"))
	DisplayServer.window_set_size(res)
	if videoSettings.get("Fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	AudioHandler.playMusic(musicStream)
	$Control/Start.grab_focus()

func _on_start_pressed() -> void:
	GameManager.setChange("res://Scenes/Levels/Level1.tscn")
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)

func _on_level_select_pressed() -> void:
	GameManager.setChange("res://Scenes/Menus/Level Select.tscn")

func _on_settings_pressed() -> void:
	GameManager.setChange("res://Scenes/Menus/Settings.tscn")

func _on_quit_pressed() -> void:
	GameManager.quitGame()

func _on_start_mouse_entered() -> void:
	$Control/Start.grab_focus()

func _on_level_select_mouse_entered() -> void:
	$Control/LevelSelect.grab_focus()

func _on_settings_mouse_entered() -> void:
	$Control/Settings.grab_focus()

func _on_quit_mouse_entered() -> void:
	$Control/Quit.grab_focus()

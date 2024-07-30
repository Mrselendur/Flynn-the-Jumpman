extends Node

@onready var musicStream: AudioStream = preload("res://Free/Audio/Music/IntroTheme.mp3")

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	var audioSettings: Dictionary = ConfigFileHandler.load_audio_settings()
	AudioServer.set_bus_mute(0, audioSettings.get("Mute"))
	
	#load volumes
	var masterVolume: float= linear_to_db(audioSettings.get("Master"))
	var musicVolume: float= linear_to_db(audioSettings.get("Music"))
	var sfxVolume: float= linear_to_db(audioSettings.get("SFX"))
	
	#check if the values are over the max allowed
	AudioServer.set_bus_volume_db(0, masterVolume)
	if masterVolume > 0:
		AudioServer.set_bus_volume_db(0, 0)
	AudioServer.set_bus_volume_db(1, musicVolume)
	if musicVolume > -6:
		AudioServer.set_bus_volume_db(1, -6)
	AudioServer.set_bus_volume_db(2, sfxVolume)
	if sfxVolume > 0:
		AudioServer.set_bus_volume_db(2, 0)

	#load video settings
	var videoSettings: Dictionary = ConfigFileHandler.load_video_settings()
	var resolutionSettings: Dictionary = ConfigFileHandler.load_resolution()
	var res: Vector2i = Vector2i(resolutionSettings.get("WindowWidth"),resolutionSettings.get("WindowHeight"))
	DisplayServer.window_set_size(res)
	if videoSettings.get("Fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	AudioHandler.play_music(musicStream)
	$Control/Start.grab_focus()

func _on_start_pressed() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.set_change("res://Scenes/Levels/Level1.tscn")

func _on_level_select_pressed() -> void:
	GameManager.set_change("res://Scenes/Menus/Level Select.tscn")

func _on_settings_pressed() -> void:
	GameManager.set_change("res://Scenes/Menus/Settings.tscn")

func _on_quit_pressed() -> void:
	GameManager.quit_game()

#functions for highlighting buttons
func _on_start_mouse_entered() -> void:
	$Control/Start.grab_focus()

func _on_level_select_mouse_entered() -> void:
	$Control/LevelSelect.grab_focus()

func _on_settings_mouse_entered() -> void:
	$Control/Settings.grab_focus()

func _on_quit_mouse_entered() -> void:
	$Control/Quit.grab_focus()

#character animation control for the menu
func _on_player_sprite_animation_finished() -> void:
	$PlayerSprite.play("idle")

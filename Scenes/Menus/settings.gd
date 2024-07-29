extends Control

#audio control
@onready var muteButton: CheckBox = $MarginContainer/VBoxContainer/Mute
@onready var masterVolume: HSlider = $MarginContainer/VBoxContainer/MasterVolume
@onready var musicVolume: HSlider = $MarginContainer/VBoxContainer/MusicVolume
@onready var sfxVolume: HSlider = $MarginContainer/VBoxContainer/SFXVolume

#video control
@onready var resolutionOptions: OptionButton = $MarginContainer/VBoxContainer/ResolutionOptions
@onready var fullscreenButton: CheckBox = $MarginContainer/VBoxContainer/Fullscreen
@onready var acceptButton: Button = $MarginContainer/VBoxContainer/HBoxContainer/AcceptChanges
@onready var backButton: Button = $MarginContainer/VBoxContainer/HBoxContainer/Back

var resolutionSettings = ConfigFileHandler.load_resolution()

var resolution: Vector2i
var windowMode

var resArray: Array[Vector2i] = [
	Vector2i(3840, 2160),
	Vector2i(2560, 1440), 
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720), 
	Vector2i(1152, 648),
	Vector2i(1024, 576)
]

func _ready() -> void:
	#set up music settings
	var audio_settings = ConfigFileHandler.load_audio_settings()
	masterVolume.value = audio_settings.get("Master")
	musicVolume.value = audio_settings.get("Music")
	sfxVolume.value = audio_settings.get("SFX")
	muteButton.button_pressed = audio_settings.get("Mute")

	#set up video settings
	var video_settings = ConfigFileHandler.load_video_settings()
	fullscreenButton.button_pressed = video_settings.get("Fullscreen")
	resolution = Vector2i(resolutionSettings.get("WindowWidth"),resolutionSettings.get("WindowHeight"))
	draw()
	acceptButton.disabled = true
	muteButton.grab_focus()

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)
	if toggled_on:
		muteButton.icon = load("res://Free/Menu/Buttons/VolumeMute.png")
	else:
		muteButton.icon = load("res://Free/Menu/Buttons/Volume.png")
	enable_accept()

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	enable_accept()

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	enable_accept()

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	enable_accept()

#emmited every time fullscreen button is pressed
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	#if toggled change to fullscreen
	if toggled_on:
		windowMode = DisplayServer.WINDOW_MODE_FULLSCREEN
	#if not change to window and enable the resolution select button
	else:
		resolutionOptions.disabled = false
		windowMode = DisplayServer.WINDOW_MODE_WINDOWED

	enable_accept()

func _on_resolution_options_item_selected(_index: int) -> void:
	var arr := resolutionOptions.text.split("x ",)
	resolution = Vector2i(arr[0].to_int(), arr[1].to_int())
	enable_accept()

#works with custom resolution
func find_resolution_text() -> void:
	var res = resArray.find(resolution) 
	if res == -1:
		return
	resolutionOptions.select(res)


func enable_accept() -> void:
	acceptButton.disabled = false

func draw() -> void:
	if fullscreenButton.button_pressed:
		windowMode = DisplayServer.WINDOW_MODE_FULLSCREEN
		resolutionOptions.disabled = true
		#disconnect signal for grabbing focus
		if resolutionOptions.is_connected("mouse_entered",_on_resolution_options_mouse_entered):
			resolutionOptions.disconnect("mouse_entered",_on_resolution_options_mouse_entered)
		resolution = DisplayServer.screen_get_size()

	else:
		windowMode = DisplayServer.WINDOW_MODE_WINDOWED
		#connect signal to grab focus 
		if !resolutionOptions.is_connected("mouse_entered",_on_resolution_options_mouse_entered):
			resolutionOptions.connect("mouse_entered",_on_resolution_options_mouse_entered)
		resolutionOptions.disabled = false
	find_resolution_text()

func _on_accept_changes_pressed() -> void:
	draw()
	#apply settings video and resolution settings
	DisplayServer.window_set_mode(windowMode)
	DisplayServer.window_set_size(resolution)
	#save settings to settings.ini
	ConfigFileHandler.save_resolution("WindowWidth", resolution.x)
	ConfigFileHandler.save_resolution("WindowHeight", resolution.y)
	ConfigFileHandler.save_video_settings("Fullscreen", fullscreenButton.button_pressed)
	ConfigFileHandler.save_audio_settings("Mute", muteButton.button_pressed)
	ConfigFileHandler.save_audio_settings("Master", masterVolume.value)
	ConfigFileHandler.save_audio_settings("Music", musicVolume.value)
	ConfigFileHandler.save_audio_settings("SFX", sfxVolume.value)

func _on_back_pressed() -> void:
	GameManager.setChange("res://Scenes/Menus/Main Menu.tscn")

#functions for highlighting buttons
func _on_mute_mouse_entered() -> void:
	muteButton.grab_focus()

func _on_master_volume_mouse_entered() -> void:
	masterVolume.grab_focus()

func _on_music_volume_mouse_entered() -> void:
	musicVolume.grab_focus()

func _on_sfx_volume_mouse_entered() -> void:
	sfxVolume.grab_focus()

func _on_fullscreen_mouse_entered() -> void:
	fullscreenButton.grab_focus()

func _on_resolution_options_mouse_entered() -> void:
	resolutionOptions.grab_focus()

func _on_back_mouse_entered() -> void:
	backButton.grab_focus()

func _on_accept_changes_mouse_entered() -> void:
	acceptButton.grab_focus()

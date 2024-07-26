extends Control

#audio control
@onready var mute: CheckBox = $MarginContainer/VBoxContainer/Mute
@onready var master_volume: HSlider = $MarginContainer/VBoxContainer/MasterVolume
@onready var music_volume: HSlider = $MarginContainer/VBoxContainer/MusicVolume
@onready var sfx_volume: HSlider = $MarginContainer/VBoxContainer/SFXVolume

#video control
@onready var resolution_options: OptionButton = $MarginContainer/VBoxContainer/ResolutionOptions
@onready var fullscreen_button: CheckBox = $MarginContainer/VBoxContainer/Fullscreen
@onready var accept_changes: Button = $MarginContainer/VBoxContainer/HBoxContainer/AcceptChanges
@onready var back: Button = $MarginContainer/VBoxContainer/HBoxContainer/Back

var resolution_settings = ConfigFileHandler.load_resolution()

var resolution: Vector2i
var window_mode

var res_array: Array[Vector2i] = [
	Vector2i(2560, 1440), 
	Vector2i(1920, 1080), 
	Vector2i(1280, 1024), 
	Vector2i(1152, 648)
]

func _ready() -> void:
	#set up music settings
	var audio_settings = ConfigFileHandler.load_audio_settings()
	master_volume.value = audio_settings.get("Master")
	music_volume.value = audio_settings.get("Music")
	sfx_volume.value = audio_settings.get("SFX")
	mute.button_pressed = audio_settings.get("Mute")

	#set up video settings
	var video_settings = ConfigFileHandler.load_video_settings()
	fullscreen_button.button_pressed = video_settings.get("Fullscreen")
	resolution = Vector2i(resolution_settings.get("WindowWidth"),resolution_settings.get("WindowHeight"))
	draw()
	accept_changes.disabled = true
	mute.grab_focus()

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)
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
		window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	#if not change to window and enable the resolution select button
	else:
		resolution_options.disabled = false
		window_mode = DisplayServer.WINDOW_MODE_WINDOWED

	enable_accept()

func _on_resolution_options_item_selected(index: int) -> void:
	match index:
		0:  
			resolution = Vector2i(2560, 1440)
		1:
			resolution = Vector2i(1920, 1080)
		2:
			resolution = Vector2i(1280, 1024)
		3: 
			resolution = Vector2i(1152, 648)
		4:
			resolution_options.set_item_disabled(4, false)
			resolution = Vector2i(resolution_settings.get("WindowWidth"),resolution_settings.get("WindowHeight"))
	enable_accept()

func find_resolution_text() -> void:
	var res = res_array.find(resolution) 
	if res != -1:
		resolution_options.select(res)
	else:
		print(res)
		resolution_options.select(4)
		resolution_options.emit_signal("item_selected", 4)

func enable_accept() -> void:
	accept_changes.disabled = false

func draw() -> void:
	if fullscreen_button.button_pressed:
		window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		resolution_options.disabled = true
		resolution = DisplayServer.screen_get_size()

	else:
		window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		resolution_options.disabled = false
	find_resolution_text()

func _on_accept_changes_pressed() -> void:
	resolution_options.set_item_disabled(4, true)
	draw()
	accept_changes.disabled = true
	#apply settings video and resolution settings
	DisplayServer.window_set_mode(window_mode)
	DisplayServer.window_set_size(resolution)
	#save settings to settings.ini
	ConfigFileHandler.save_resolution("WindowWidth", resolution.x)
	ConfigFileHandler.save_resolution("WindowHeight", resolution.y)
	ConfigFileHandler.save_video_settings("Fullscreen", fullscreen_button.button_pressed)
	ConfigFileHandler.save_audio_settings("Mute", mute.button_pressed)
	ConfigFileHandler.save_audio_settings("Master", master_volume.value)
	ConfigFileHandler.save_audio_settings("Music", music_volume.value)
	ConfigFileHandler.save_audio_settings("SFX", sfx_volume.value)
	

func _on_back_pressed() -> void:
	GameManager.setChange("res://Scenes/Menus/Main Menu.tscn")

func _on_mute_mouse_entered() -> void:
	mute.grab_focus()

func _on_master_volume_mouse_entered() -> void:
	master_volume.grab_focus()

func _on_music_volume_mouse_entered() -> void:
	music_volume.grab_focus()

func _on_sfx_volume_mouse_entered() -> void:
	sfx_volume.grab_focus()

func _on_fullscreen_mouse_entered() -> void:
	fullscreen_button.grab_focus()

func _on_resolution_options_mouse_entered() -> void:
	resolution_options.grab_focus()

func _on_back_mouse_entered() -> void:
	back.grab_focus()

func _on_accept_changes_mouse_entered() -> void:
	accept_changes.grab_focus()

extends Control

@onready var resolution_options: OptionButton = $MarginContainer/VBoxContainer/ResolutionOptions
@onready var fullscreen_button: CheckBox = $MarginContainer/VBoxContainer/Fullscreen
@onready var accept_changes: Button = $MarginContainer/VBoxContainer/HBoxContainer/AcceptChanges

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

	var video_settings = ConfigFileHandler.load_video_settings()
	fullscreen_button.button_pressed = video_settings.get("Fullscreen")
	
	resolution = Vector2i(resolution_settings.get("WindowWidth"),resolution_settings.get("WindowHeight"))
	if fullscreen_button.button_pressed:
		window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		resolution = DisplayServer.screen_get_size()
	else:
		window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	draw()
	accept_changes.disabled = true

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
	#print("hello")
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
		resolution_options.disabled = true
		resolution = DisplayServer.screen_get_size()
	else:
		resolution_options.disabled = false
	find_resolution_text()

func _on_accept_changes_pressed() -> void:
	resolution_options.set_item_disabled(4, true)
	draw()
	accept_changes.disabled = true
	#apply settings 
	DisplayServer.window_set_mode(window_mode)
	DisplayServer.window_set_size(resolution)
	print(resolution)
	#save settings to settings.ini
	ConfigFileHandler.save_resolution("WindowWidth", resolution.x)
	ConfigFileHandler.save_resolution("WindowHeight", resolution.y)
	ConfigFileHandler.save_video_settings("Fullscreen", fullscreen_button.button_pressed)
	

func _on_back_pressed() -> void:
	GameManager.setChange("res://Scene/Main Menu.tscn")

extends Node

@onready var score = $Score

@onready var musicStream: AudioStream = preload("res://Free/Audio/Music/gameover.wav")

func _ready() -> void:
	var arr = AudioHandler.get_children()
	for i in arr:
		i.queue_free()
	AudioHandler.playMusic(musicStream)
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	score.text = "Score: " + str(GameManager.getAllPoints())
	GameManager.resetAllPoints()

func _on_restart_pressed() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.setChange(GameManager.currentLevel)

func _on_menu_pressed() -> void:
	GameManager.setChange("res://Scene/Main Menu.tscn")

func _on_menu_button_up():
	_button_released($Control/Menu)

func _on_menu_button_down():
	_button_pressed($Control/Menu)
	
func _on_restart_button_up():
	_button_released($Control/Restart)
	
func _on_restart_button_down():
	_button_pressed($Control/Restart)
	
func _button_pressed(button: TextureButton) -> void:
	button.scale -= Vector2(0.5, 0.5) 

func _button_released(button: TextureButton) -> void:
	button.scale += Vector2(0.5, 0.5)

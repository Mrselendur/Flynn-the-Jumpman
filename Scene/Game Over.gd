extends Node

@onready var score = $Score

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	score.text = "Score: " + str(GameManager.getAllPoints())
	GameManager.resetAllPoints()

func _on_restart_pressed() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.setChange("res://Scene/level1.tscn")

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

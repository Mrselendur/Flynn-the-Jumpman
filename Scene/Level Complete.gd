extends Node

@onready var score = $Score

func _ready() -> void:
	score.text = "Score: " + str(GameManager.getAllPoints())

func _on_menu_pressed() -> void:
	GameManager.resetAllPoints()
	GameManager.setChange("res://Scene/Main Menu.tscn")
	
func _on_menu_button_up():
	_button_released($Menu)

func _on_menu_button_down():
	_button_pressed($Menu)
	
func _button_pressed(button: TextureButton) -> void:
	button.scale = Vector2(5, 5)

func _button_released(button: TextureButton) -> void:
	button.scale = Vector2(5.5, 5.5)

extends Node

func _on_start_pressed() -> void:
	GameManager.setChange("res://Scene/level1.tscn")

func _on_level_select_pressed() -> void:
	GameManager.setChange("res://Scene/Level Select.tscn")

func _on_quit_pressed() -> void:
	GameManager.quitGame()
#below here are functions for old control (ignore for now, maybe even delete later)
func _on_start_button_down():
	_button_pressed($Control/Start)

func _on_start_button_up():
	_button_released($Control/Start)

func _on_level_select_button_down():
	_button_pressed($Control/LevelSelect)

func _on_level_select_button_up():
	_button_released($Control/LevelSelect)

func _on_quit_button_down():
	_button_pressed($Control/Quit)

func _on_quit_button_up():
	_button_released($Control/Quit)

func _button_pressed(button: TextureButton) -> void:
	button.scale -= Vector2(0.5, 0.5) 

func _button_released(button: TextureButton) -> void:
	button.scale += Vector2(0.5, 0.5)

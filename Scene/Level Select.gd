extends Control

func _on_level_one_pressed() -> void:
	GameManager.setChange("res://Scene/level1.tscn")

func _on_level_two_pressed() -> void:
	GameManager.setChange("res://Scene/level1.tscn")

func _on_level_three_pressed() -> void:
	GameManager.setChange("res://Scene/level1.tscn")

func _on_back_pressed() -> void:
	GameManager.setChange("res://Scene/Main Menu.tscn")

func _on_level_one_button_up() -> void:
	_button_released($Control/LevelOne)

func _on_level_one_button_down() -> void:
	_button_pressed($Control/LevelOne)

func _on_level_two_button_up() -> void:
	_button_released($Control/LevelTwo)

func _on_level_two_button_down() -> void:
	_button_pressed($Control/LevelTwo)

func _on_level_three_button_up() -> void:
	_button_released($Control/LevelThree)

func _on_level_three_button_down() -> void:
	_button_pressed($Control/LevelThree)

func _on_back_button_up():
	_button_released($Control/Back)

func _on_back_button_down():
	_button_pressed($Control/Back)

func _button_pressed(button: TextureButton) -> void:
	button.scale = Vector2(7, 7)

func _button_released(button: TextureButton) -> void:
	button.scale = Vector2(7.5, 7.5)







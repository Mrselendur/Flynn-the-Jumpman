extends Control

@onready var levelOne: TextureButton = $Control/LevelOne
@onready var levelTwo: TextureButton = $Control/LevelTwo
@onready var levelThree: TextureButton = $Control/LevelThree
@onready var back: Button = $Control/Back


func _ready() -> void:
	levelOne.grab_focus()

#functioins for button control 
func _on_level_one_pressed() -> void:
	GameManager.setChange("res://Scenes/Levels/Level1.tscn")

func _on_level_two_pressed() -> void:
	GameManager.setChange("res://Scenes/Levels/Level2.tscn")

func _on_level_three_pressed() -> void:
	GameManager.setChange("res://Scenes/Levels/Level3.tscn")

func _on_back_pressed() -> void:
	GameManager.setChange("res://Scenes/Menus/Main Menu.tscn")

#functions for texture button visual changes
func _on_level_one_button_up() -> void:
	_button_released(levelOne)

func _on_level_one_button_down() -> void:
	_button_pressed(levelOne)

func _on_level_two_button_up() -> void:
	_button_released(levelTwo)

func _on_level_two_button_down() -> void:
	_button_pressed(levelTwo)

func _on_level_three_button_up() -> void:
	_button_released(levelThree)

func _on_level_three_button_down() -> void:
	_button_pressed(levelThree)

func _button_pressed(button: TextureButton) -> void:
	button.scale = Vector2(7, 7)

func _button_released(button: TextureButton) -> void:
	button.scale = Vector2(7.5, 7.5)

#functions for highlighting buttons
func _on_level_one_mouse_entered() -> void:
	levelOne.grab_focus()

func _on_level_two_mouse_entered() -> void:
	levelTwo.grab_focus()


func _on_level_three_mouse_entered() -> void:
	levelThree.grab_focus()

func _on_back_mouse_entered() -> void:
	back.grab_focus()

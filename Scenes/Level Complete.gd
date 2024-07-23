extends Node

@onready var score = $Score

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	score.text = "Score: " + str(GameManager.getAllPoints())

func _on_return_to_menu_pressed() -> void:
	GameManager.resetAllPoints()
	GameManager.setChange("res://Scenes/Main Menu.tscn")

func _on_next_level_pressed() -> void:
	var previousLevel = GameManager.currentLevel
	previousLevel = previousLevel.get_slice("Level", 2).trim_suffix(".tscn")
	previousLevel = previousLevel.to_int()
	if previousLevel >= 3:
		return
	var nextLevel: int = previousLevel + 1
	GameManager.setChange("res://Scenes/Levels/Level"+ str(nextLevel) +".tscn")

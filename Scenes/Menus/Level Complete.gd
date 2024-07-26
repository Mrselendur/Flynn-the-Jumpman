extends Node

@onready var score = $Score
@onready var previousLevel = GameManager.currentLevel

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	previousLevel = previousLevel.get_slice("Level", 2).trim_suffix(".tscn")
	previousLevel = previousLevel.to_int()
	if previousLevel >= 3:
		$GameCompleteText.visible = true
		$LevelCompleteText.visible = false
		$Control/NextLevel.disabled = true
	score.text = "Score: " + str(GameManager.getAllPoints())
	$Control/NextLevel.grab_focus()

func _on_next_level_pressed() -> void:
	var nextLevel: int = previousLevel + 1
	GameManager.setChange("res://Scenes/Levels/Level"+ str(nextLevel) +".tscn")

func _on_return_to_menu_pressed() -> void:
	GameManager.resetAllPoints()
	GameManager.setChange("res://Scenes/Menus/Main Menu.tscn")


func _on_next_level_mouse_entered() -> void:
	$Control/NextLevel.grab_focus()

func _on_return_to_menu_mouse_entered() -> void:
	$Control/ReturnToMenu.grab_focus()

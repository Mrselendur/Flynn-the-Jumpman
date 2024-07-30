extends Node

@onready var score = $Score

@onready var nextLevelButton: Button = $Control/NextLevel
@onready var menuButton: Button = $Control/Menu
var musicStream = preload("res://Free/Audio/Music/LevelComplete.mp3")
var previousLevel = GameManager.currentLevel

func _ready() -> void:
	AudioHandler.stop_music()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	var arr = AudioHandler.get_children()
	for i in arr:
		i.queue_free()
	AudioHandler.play_music(musicStream)
	
	previousLevel = previousLevel.get_slice("Level", 2).trim_suffix(".tscn")
	previousLevel = previousLevel.to_int()
	score.text = "Score: " + str(GameManager.get_all_points())
	if previousLevel < 3:
		nextLevelButton.grab_focus()
		return 
	$GameCompleteText.visible = true
	$LevelCompleteText.visible = false
	nextLevelButton.disabled = true
	nextLevelButton.focus_mode = Control.FOCUS_NONE
	nextLevelButton.disconnect("mouse_entered", _on_next_level_mouse_entered)
	menuButton.grab_focus()

func _on_next_level_pressed() -> void:
	var nextLevel: int = previousLevel + 1
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.set_change("res://Scenes/Levels/Level"+ str(nextLevel) +".tscn")

func _on_return_to_menu_pressed() -> void:
	GameManager.reset_all_points()
	GameManager.set_change("res://Scenes/Menus/Main Menu.tscn")

#functions for highlighting buttons
func _on_next_level_mouse_entered() -> void:
	nextLevelButton.grab_focus()

func _on_return_to_menu_mouse_entered() -> void:
	menuButton.grab_focus()

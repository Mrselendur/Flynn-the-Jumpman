extends Node

@onready var nextLevelButton: Button = $Control/NextLevel
@onready var menuButton: Button = $Control/Menu
@onready var intPreviousLevel: int

func _ready() -> void:
	var strPreviousLevel: String = GameManager.get_current_level()
	var musicStream: Resource = preload("res://Free/Audio/Music/LevelComplete.mp3")
	
	GameManager.set_current_level("res://Scenes/Menus/Level Complete.tscn")
	AudioHandler.stop_music()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	var arr: Array[Node] = AudioHandler.get_children()
	if !arr.is_empty():
		for i in arr:
			i.queue_free()
	AudioHandler.play_music(musicStream)
	strPreviousLevel = strPreviousLevel.get_slice("Level", 2).trim_suffix(".tscn")
	intPreviousLevel = strPreviousLevel.to_int()
	GameManager.add_all_points()
	$Score.text = "Score: " + str(GameManager.get_all_points())
	
	if intPreviousLevel < 3:
		nextLevelButton.grab_focus()
		return 
	$GameCompleteText.visible = true
	$LevelCompleteText.visible = false
	nextLevelButton.disabled = true
	nextLevelButton.focus_mode = Control.FOCUS_NONE
	nextLevelButton.disconnect("mouse_entered", _on_next_level_mouse_entered)
	menuButton.grab_focus()

func _on_next_level_pressed() -> void:
	var nextLevel: int = intPreviousLevel + 1
	GameManager.reset_level_points()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.set_change("res://Scenes/Levels/Level" + str(nextLevel) + ".tscn")

func _on_return_to_menu_pressed() -> void:
	GameManager.reset_all_points()
	GameManager.set_change("res://Scenes/Menus/Main Menu.tscn")

#functions for highlighting buttons
func _on_next_level_mouse_entered() -> void:
	nextLevelButton.grab_focus()

func _on_return_to_menu_mouse_entered() -> void:
	menuButton.grab_focus()

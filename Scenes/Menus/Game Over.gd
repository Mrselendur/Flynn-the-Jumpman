extends Node

@onready var currentLevel = GameManager.get_current_level()

func _ready() -> void:
	var musicStream: AudioStream = preload("res://Free/Audio/Music/GameOver.mp3")
	GameManager.set_current_level("res://Scenes/Menus/Game Over.tscn")
	AudioHandler.stop_music()
	var arr = AudioHandler.get_children()
	for i in arr:
		i.queue_free()
	AudioHandler.play_music(musicStream)
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	$Score.text = "Score: " + str(GameManager.get_all_points() + GameManager.get_level_points())
	GameManager.reset_level_points()
	$Control/Restart.grab_focus()

func _on_restart_pressed() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.reset_level_points()
	GameManager.set_change(currentLevel)

func _on_menu_pressed() -> void:
	GameManager.reset_all_points()
	GameManager.set_change("res://Scenes/Menus/Main Menu.tscn")

#functions for highlighting buttons
func _on_restart_mouse_entered() -> void:
	$Control/Restart.grab_focus()

func _on_menu_mouse_entered() -> void:
	$Control/Menu.grab_focus()

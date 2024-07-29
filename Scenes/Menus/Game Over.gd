extends Node

@onready var score = $Score
@onready var musicStream: AudioStream = preload("res://Free/Audio/Music/GameOver.mp3")
 
var currentLevel = GameManager.currentLevel

func _ready() -> void:
	var arr = AudioHandler.get_children()
	for i in arr:
		i.queue_free()
	AudioHandler.playMusic(musicStream)
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	score.text = "Score: " + str(GameManager.getAllPoints())
	GameManager.resetLevelPoints()
	$Control/Restart.grab_focus()

func _on_restart_pressed() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.setChange(currentLevel)

func _on_menu_pressed() -> void:
	GameManager.setChange("res://Scenes/Menus/Main Menu.tscn")

#functions for highlighting buttons
func _on_restart_mouse_entered() -> void:
	$Control/Restart.grab_focus()

func _on_menu_mouse_entered() -> void:
	$Control/Menu.grab_focus()

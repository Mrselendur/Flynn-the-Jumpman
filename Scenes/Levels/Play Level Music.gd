extends Node2D

@onready var musicStream: AudioStream = load("res://Free/Audio/Music/" + self.name + ".mp3")
var scenePath: String = "res://Scenes/Levels/" + self.name + ".tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.get_current_level() == scenePath:
		return
	GameManager.set_current_level(scenePath)
	AudioHandler.stop_music()
	AudioHandler.play_music(musicStream)

extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var musicStream: AudioStream = load("res://Free/Audio/Music/" + self.name + ".mp3")
	AudioHandler.playMusic(musicStream)

extends Node2D

@onready var music_stream: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_stream = load("res://Free/Audio/Music/" + self.name + ".mp3")
	AudioHandler.playMusic(music_stream)

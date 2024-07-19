extends Node2D

@onready var music_stream: AudioStream = preload("res://Free/Audio/Music/Grasslands Theme.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioHandler.playMusic(music_stream)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

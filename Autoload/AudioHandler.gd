extends AudioStreamPlayer

func playMusic(stream_01: AudioStream, volume = 0.0) -> void:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream_01
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	fx_player.bus = "SFX"
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	fx_player.queue_free()

func playFX(stream_01: AudioStream, volume = 0.0) -> void:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream_01
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	fx_player.bus = "SFX"
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	fx_player.queue_free()
	
func playFX_2D(stream_01: AudioStream, position: Vector2, volume = 0.0, distance = 1000) -> void:
	var fx_player = AudioStreamPlayer2D.new()
	fx_player.stream = stream_01
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	fx_player.bus = "SFX"
	fx_player.position = position
	fx_player.max_distance = distance
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	fx_player.queue_free()

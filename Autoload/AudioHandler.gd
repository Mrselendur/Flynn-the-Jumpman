extends AudioStreamPlayer

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

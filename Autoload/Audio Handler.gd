extends AudioStreamPlayer

func play_music(music: AudioStream, volume = 0.0) -> void:
	if stream == music:
		return
	stream = music
	name = "FX_PLAYER"
	volume_db = volume
	bus = "Music"
	play()
	
func stop_music() -> void:
	if !self.playing:
		return
	self.stop()

func play_fx(sfx: AudioStream, volume = 0.0) -> void:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = sfx
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	fx_player.bus = "SFX"
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	fx_player.queue_free()

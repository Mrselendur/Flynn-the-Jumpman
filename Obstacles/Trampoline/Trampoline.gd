extends Area2D
@onready var animatedSprite = $AnimatedSprite2D
@onready var fx = preload("res://Free/Audio/Sound Effects/trampoline.wav")
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

const force = -750.0

func _on_body_entered(body):
	if(!body.is_in_group("Player")):
		return
	body.jumpCount = 0                        #reset jump counter
	body.emitting = false                      #reset particles
	body.jump(force)                           #apply force to make the player jump high
	audio.play()
	animatedSprite.play("Launch")             #change to launch animation
	await animatedSprite.animation_finished   #wait for end of animation
	animatedSprite.play("idle")               #change back to idle animation

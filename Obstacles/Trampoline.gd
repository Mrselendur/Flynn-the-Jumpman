extends Area2D

@export var force = -750.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var fx = preload("res://Free/Audio/Sound Effects/trampoline.wav")
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
func _on_body_entered(body):
	if(!body.is_in_group("Player")):
		return
	body.jump_count = 0                        #reset jump counter
	body.emmiting = false                      #reset particles
	body.jump(force)                           #apply force to make the player jump high
	body.active_animations()
	audio.play()
	animated_sprite.play("Launch")             #change to launch animation
	await animated_sprite.animation_finished   #wait for end of animation
	animated_sprite.play("idle")               #change back to idle animation

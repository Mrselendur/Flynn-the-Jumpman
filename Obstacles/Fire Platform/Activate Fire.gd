extends Node2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var fire = $Fire/CollisionShape2D
@onready var fireAudio: AudioStreamPlayer2D = $Fire/FireAudio

const TIMER := 3.0                #timer to turn off fire

var isSet: bool = false           #variable to reset platform

#When a body enteres Activate area
func _on_activate_body_entered(body):      
	if !body.is_in_group("Player"): 
		return
	if isSet:           #prevents code running while 
		return          #animation is still playing
	isSet = true                                  
	animatedSprite.play("hit")
	await animatedSprite.animation_finished       #wait for animation to finish
	animatedSprite.play("on")
	fireAudio.play()
	fire.disabled = false                          #enable the fire area
	await get_tree().create_timer(TIMER).timeout   #wait 3 seconds before
	animatedSprite.play("off")                     #turning of fire
	fire.disabled = true                           #disable fire
	isSet = false                                  #reset platform

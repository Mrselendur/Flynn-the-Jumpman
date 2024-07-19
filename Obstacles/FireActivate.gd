extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var fire = $Fire/CollisionShape2D
@onready var fire_audio: AudioStreamPlayer2D = $Fire/FireAudio

const TIMER := 3.0                       #timer to turn off fire

var isSet: bool = false                    #variable to reset platform

#When a body enteres Activate area
func _on_activate_body_entered(body):      
	if(body.is_in_group("Player")):                        #if body is in Player
		if isSet:                                #makes sure code doesn't execute a second
			return                               #time while the fire is still running
		isSet = true                                  
		animated_sprite.play("hit")
		await animated_sprite.animation_finished       #wait for animation to finish
		animated_sprite.play("on")
		fire_audio.play()
		fire.disabled = false                          #enable the fire area
		await get_tree().create_timer(TIMER).timeout   #wait 3 seconds before
		animated_sprite.play("off")                    #turning of fire
		fire.disabled = true                           #disable fire
		isSet = false                                  #reset platform

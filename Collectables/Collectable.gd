extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var fx = preload("res://Free/Audio/90s-game-ui-3-185096.wav")
@export var pointsGiven: int

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		$GPUParticles2D.emitting = true
		collision_shape.set_deferred("disabled", true)    #disable collision                       
		animated_sprite.play("Collected")                 #change animation
		GameManager.addPoints(pointsGiven)                   #add points to the score
		AudioHandler.playFX(fx, -10)
		await(animated_sprite.animation_finished)         #wait for animation to end
		queue_free()                                         #delete whole apple node

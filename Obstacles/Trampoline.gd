extends Area2D

@export var force = -750.0

@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_body_entered(body):
	if(body.is_in_group("Player")):
		body.velocity.y = force
		animated_sprite_2d.play("Launch")
		await(animated_sprite_2d.animation_finished)
		animated_sprite_2d.play("default")

extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $Fire/Area2D/CollisionShape2D

const TIMER: int = 3

var isSet: bool = false

func _on_activate_body_entered(body):
	if(body.is_in_group("Player")):
		if(false == isSet):
			isSet = true
			animated_sprite_2d.play("hit")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("on")
			collision_shape_2d.disabled = false
			await get_tree().create_timer(TIMER).timeout
			animated_sprite_2d.play("off")
			collision_shape_2d.disabled = true
			isSet = false


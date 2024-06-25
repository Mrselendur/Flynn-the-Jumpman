extends Node2D

@onready var sprite_2d = $AnimatedSprite2D
@onready var fire = $Fire/CollisionShape2D

const TIMER: int = 3

var isSet: bool = false

func _on_activate_body_entered(body):
	if(body.is_in_group("Player")):
		if(false == isSet):
			isSet = true
			sprite_2d.play("hit")
			await sprite_2d.animation_finished
			sprite_2d.play("on")
			fire.disabled = false
			await get_tree().create_timer(TIMER).timeout
			sprite_2d.play("off")
			fire.disabled = true
			isSet = false


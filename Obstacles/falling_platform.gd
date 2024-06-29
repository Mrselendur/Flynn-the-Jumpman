extends AnimatableBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

func _on_trigger_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player") && body.is_on_floor()):   #makes sure that the player is standing on the platform
		animation_player.play("shake")                      #play shake animation

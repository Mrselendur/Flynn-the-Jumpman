extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var player_detect = $PlayerDetect/CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox/Area2D/CollisionShape2D

const BLINK_TIME = 1000
var counter = BLINK_TIME

func _process(_delta):
	counter -= 1
	if(0 == counter):
		sprite.play("blink")
		await sprite.animation_finished
		sprite.play("idle")
		counter = BLINK_TIME

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		animation_player.play("fall")
		print("Fall")
		player_detect.set_deferred("disabled", true)
		await animation_player.animation_finished
		sprite.play("hit ground")
		hitbox.set_deferred("disabled", true)
		await sprite.animation_finished
		sprite.play("idle")
		await get_tree().create_timer(2).timeout
		animation_player.play("climb up")
		await animation_player.animation_finished
		hitbox.set_deferred("disabled", false)
		player_detect.set_deferred("disabled", false)

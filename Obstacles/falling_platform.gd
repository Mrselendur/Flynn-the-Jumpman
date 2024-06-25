extends Node2D

@onready var init_pos : Vector2
@onready var platform = $StaticBody2D
@onready var fall_area = $Area2D/CollisionShape2D
@onready var animated_sprite_2d = $StaticBody2D/AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

func _ready():
	init_pos = platform.global_position

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player") && body.is_on_floor()):
		animation_player.play("fall")
		await animation_player.animation_finished
		animated_sprite_2d.play("off")
		fall()
		

func fall():
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(platform, "global_position", fall_area.global_position, 1)
	await get_tree().create_timer(5).timeout
	return_fall()
	
func return_fall():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	animated_sprite_2d.play("on")
	tween.tween_property(platform, "global_position", init_pos, 1)

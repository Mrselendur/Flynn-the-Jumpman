extends Node2D

@onready var platform = $StaticBody2D
@onready var fall_area = $FallArea/CollisionShape2D
@onready var animated_sprite = $StaticBody2D/AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

#Vector2 variable for the starting position 
@onready var init_pos : Vector2        

#timer for waiting before going back up
const TIMER := 5.0           

func _ready():
	init_pos = platform.global_position            #set initial posotion to the global position in the scene

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player") && body.is_on_floor()):   #makes sure that the player is standing on the platform
		animation_player.play("shake")                      #play shake animation
		await animation_player.animation_finished           #wait for animation to finish
		animated_sprite.play("off")                         #change sprite animation to off
		fall()
		

func fall():
	#tween for a falling animation
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(platform, "global_position", fall_area.global_position, 1)
	await get_tree().create_timer(TIMER).timeout               #wait 5 seconds
	return_fall()
	
func return_fall():
	#tween for going back up animation
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	animated_sprite.play("on")                             #change back sprite animation 
	tween.tween_property(platform, "global_position", init_pos, 1)

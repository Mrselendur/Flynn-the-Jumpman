extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed: float = 1

const BLINK_TIME := 10.0      #blink timer for blink animation

var blink: bool = false

func _process(_delta):
	if(false == blink):
		blink = true           #cannot blink again before animation is over
		await get_tree().create_timer(BLINK_TIME).timeout    #blink every 10 seconds
		animated_sprite.play("blink")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
		blink = false            #reset blink so rockhead can blink again in another 10 seconds

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation_player.speed_scale = speed
		animation_player.play("fall")

extends "Moving Object.gd"

@export var playerWait: bool = false

@onready var trigger: Area2D = $AnimatableBody2D/Trigger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spritePath = "res://Free/Traps/Platforms/Chain.png"
	animationPlayer.speed_scale = openSpeed
	#super() runs the _ready function of the inherited script
	super()
	#gray platform starts instantly and goes back and forward
	if !playerWait:
		$AnimatableBody2D/AnimatedSprite2D.set_animation("gray_moving")
		animationPlayer.play("gray_on")
	#brown platform starts when the player steps on it and stops at the end
	else:
		$AnimatableBody2D/AnimatedSprite2D.set_animation("brown_idle")
		trigger.connect("body_entered",_on_trigger_body_entered)
	

func _on_trigger_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Player"):
		return
	if body.is_on_floor():
		animationPlayer.play("brown_on")

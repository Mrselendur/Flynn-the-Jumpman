extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

@export var pointsGiven: int

var disable_collision: bool = false

func _process(_delta) -> void:
	collision_shape_2d.disabled = disable_collision

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		disable_collision = true
		animated_sprite_2d.play("Collected")
		GameManager.addPoints(pointsGiven)
		await(animated_sprite_2d.animation_finished)
		queue_free()

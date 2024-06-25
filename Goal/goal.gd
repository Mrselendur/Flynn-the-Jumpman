extends Node2D

@export var required_points: int 

@onready var collision_shape_2d = $Area2D/CollisionShape2D

var is_shown: bool = false

func _process(_delta) -> void:
	if((required_points <= GameManager.getLevelPoints()) && (false == is_shown)):
		collision_shape_2d.disabled = false
		self.visible = true
		is_shown = true

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		await(body.get_node("AnimatedSprite2D").animation_finished)
		GameManager.setChange("res://Scene/Level Complete.tscn")

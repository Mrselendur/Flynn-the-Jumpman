extends Node2D

@onready var init_pos : Vector2
@onready var cube = $StaticBody2D
@onready var zone = $Area2D/CollisionShape2D

func _ready():
	init_pos = cube.global_position

func _unhandled_input(event):
	if Input.is_action_just_pressed("left"):
		fall()

func fall():
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(cube, "global_position", zone.global_position, 0.5)
	await get_tree().create_timer(3).timeout
	return_fall()
	
func return_fall():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(cube, "global_position", init_pos, 0.5)

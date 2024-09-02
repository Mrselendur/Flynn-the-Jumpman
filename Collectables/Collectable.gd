extends Node2D
@export var pointsGiven: int

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var label: Label = $PointsText/Label
@onready var pointsParticle: CPUParticles2D = $PointsParticle
const fx: Resource = preload("res://Free/Audio/Sound Effects/collected.wav")

func _ready() -> void:
	label.text = str(pointsGiven)

func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		return
	pointsParticle.emitting = true
	area_2d.set_deferred("monitoring", false)
	animated_sprite.play("Collected")           
	GameManager.add_level_points(pointsGiven)        
	AudioHandler.play_fx(fx, -15)
	await animated_sprite.animation_finished        
	queue_free()      #delete node

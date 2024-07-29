extends Node2D
@export var pointsGiven: int

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var label = $PointsText/Label
@onready var pointsParticle: CPUParticles2D = $PointsParticle
@onready var fx = preload("res://Free/Audio/Sound Effects/collected.wav")


func _ready() -> void:
	label.text = str(pointsGiven)

func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		return
	pointsParticle.emitting = true
	collision_shape.set_deferred("disabled", true)    #disable collision                       
	animated_sprite.play("Collected")                 #change animation
	GameManager.addPoints(pointsGiven)                #add points to the score
	AudioHandler.playFX(fx, -15)
	await(animated_sprite.animation_finished)         #wait for animation to end
	queue_free()                #delete whole collectable node

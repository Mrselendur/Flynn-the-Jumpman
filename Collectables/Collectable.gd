extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var label = $PointsText/Label
@onready var particles: GPUParticles2D = $PointsParticles

@onready var fx = preload("res://Free/Audio/collected.wav")

@export var pointsGiven: int


func _ready() -> void:
	label.text = str(pointsGiven)

func _on_area_2d_body_entered(body):
	if(body.is_in_group("Player")):
		particles.emitting = true
		collision_shape.set_deferred("disabled", true)    #disable collision                       
		animated_sprite.play("Collected")                 #change animation
		GameManager.addPoints(pointsGiven)                #add points to the score
		AudioHandler.playFX(fx, -10)
		await(animated_sprite.animation_finished)         #wait for animation to end
		queue_free()                #delete whole apple node

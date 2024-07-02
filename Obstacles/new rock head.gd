extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rock_head: Path2D = $"."
@onready var player_detect: Area2D = $AreaDetectPosition/PlayerDetect
@onready var collision_shape: CollisionShape2D = $AreaDetectPosition/PlayerDetect/DetectionShape

@export var speed: float = 2

const BLINK_TIME := 10.0    #blink timer for blink animation
const OFFSET = 40     #offseting player detect area to start at the edge of the rockhead 
const WIDTH = 86      #setting up the area to be the right size

var blink: bool = false

func _ready() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()
	var point_position = rock_head.curve.get_point_position(1)
	var size_vector: Vector2
	var pos_vector: Vector2
	if point_position.x != 0:
		size_vector = Vector2(abs(point_position.x), WIDTH)
		pos_vector = Vector2((point_position.x * 0.5),0)
		if point_position.x > 0:
			pos_vector.x += OFFSET
		else:
			pos_vector.x -= OFFSET
	else:
		size_vector = Vector2(WIDTH,abs(point_position.y))
		pos_vector = Vector2(0, (point_position.y * 0.5))
		if point_position.y > 0:
			pos_vector.y += OFFSET
		else:
			pos_vector.y -= OFFSET
	player_detect.position = pos_vector
	shape.set_size(size_vector)
	collision_shape.shape = shape

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

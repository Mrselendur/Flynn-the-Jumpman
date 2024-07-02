extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rock_head: Path2D = $"."
@onready var player_detect: Area2D = $AreaDetectPosition/PlayerDetect
@onready var detection_collision: CollisionShape2D = $AreaDetectPosition/PlayerDetect/DetectionShape
@onready var body_collision: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var death_area: Area2D = $AnimatableBody2D/Death

@export var speed: float = 2

const BLINK_TIME := 10.0    #blink timer for blink animation
const OFFSET_DETECTION = 40     #offseting player detect area to start at the edge of the rockhead
const OFFSET_COLLISION = 3
const OFFSET_DEATH = 36
const WIDTH = 86      #setting up the area to be the size of the path

var blink: bool = false
var animation: String

func _ready() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()
	var point_position = rock_head.curve.get_point_position(1)
	var size_vector: Vector2
	var pos_vector: Vector2
	if point_position.x != 0:
		size_vector = Vector2(abs(point_position.x), WIDTH)
		pos_vector = Vector2((point_position.x * 0.5),0)
		body_collision.rotation_degrees = 90
		death_area.rotation_degrees = 90
		if point_position.x > 0:
			animation = "hit right"
			pos_vector.x += OFFSET_DETECTION
			body_collision.position = Vector2(-OFFSET_COLLISION, 0)
			death_area.position = Vector2(OFFSET_DEATH, 0)
		else:
			animation = "hit left"
			pos_vector.x -= OFFSET_DETECTION
			body_collision.position = Vector2(OFFSET_COLLISION, 0)
			death_area.position = Vector2(-OFFSET_DEATH, 0)
	else:
		size_vector = Vector2(WIDTH,abs(point_position.y))
		pos_vector = Vector2(0, (point_position.y * 0.5))
		if point_position.y > 0:
			animation = "hit bottom"
			pos_vector.y += OFFSET_DETECTION
			body_collision.position = Vector2(0, -OFFSET_COLLISION)
			death_area.position = Vector2(0, OFFSET_DEATH)

		else:
			animation = "hit top"
			pos_vector.y -= OFFSET_DETECTION
			body_collision.position = Vector2(0, OFFSET_COLLISION)
			death_area.position = Vector2(0, -OFFSET_DEATH)

	player_detect.position = pos_vector
	shape.set_size(size_vector)
	detection_collision.shape = shape

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
		
func _play_animation():
	animated_sprite.play(animation)
	

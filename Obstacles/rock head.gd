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
const OFFSET_DETECTION = 40     #offset for player detect area to start at the edge of the rockhead
const OFFSET_COLLISION = 3      #offset for collision shape to fill the sprite of the rockhead
const OFFSET_DEATH = 36         #offset for death area to be at the point where the rockhead is going towards
const WIDTH = 86      #setting up the area to be the size of the path

var blink: bool = false
var animation: String    #string to handle the different names of the different hit animatons      

func _ready() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()      #creating a new shape
	var point_pos = rock_head.curve.get_point_position(1)   #getting the last point of the path (only using straight lines)
	var size_vector: Vector2        #size of the detection collision
	var pos_vector: Vector2         #position of the detection area
	
	#path is either left or right
	if point_pos.x != 0:
		#set x to absolute of point.x to work with negatives
		#set y to WIDTH 
		size_vector = Vector2(abs(point_pos.x), WIDTH)  
		#detection area's center is the the center of the path line
		pos_vector = Vector2((point_pos.x * 0.5),0)    
		#rotating body and death area by 90 degrees when facing left or right   
		body_collision.rotation_degrees = 90      
		death_area.rotation_degrees = 90
		#path is left
		if point_pos.x > 0:
			#get animation    
			animation = "hit right"
			#offset detection area and death area to the right    
			pos_vector.x += OFFSET_DETECTION
			death_area.position = Vector2(OFFSET_DEATH, 0)    
			#offset collision of body slightly to the left to fit the sprite
			body_collision.position = Vector2(-OFFSET_COLLISION, 0)  

		#path is right
		else:     
			animation = "hit left" 
			#offset detection and death area to the left
			pos_vector.x -= OFFSET_DETECTION      
			death_area.position = Vector2(-OFFSET_DEATH, 0)
			#offset collision of body slightly to the right to fit the sprite
			body_collision.position = Vector2(OFFSET_COLLISION, 0)  

	#path is either up or down
	else:
		#set x to  WIDTH
		#set y to absolute of point.y to work with negatives 
		size_vector = Vector2(WIDTH,abs(point_pos.y))
		#detection area's center is the the center of the path line
		pos_vector = Vector2(0, (point_pos.y * 0.5))
		#path is down
		if point_pos.y > 0:       
			animation = "hit bottom"
			#offset detection and death area to the bottom      
			pos_vector.y += OFFSET_DETECTION
			death_area.position = Vector2(0, OFFSET_DEATH)
			#offset collision of body slightly to the top to fit the sprite
			body_collision.position = Vector2(0, -OFFSET_COLLISION)
			
		#path is up
		else:         
			animation = "hit top"
			#offset detection and death area to the top    
			pos_vector.y -= OFFSET_DETECTION
			death_area.position = Vector2(0, -OFFSET_DEATH)
			#offset collision of body slightly to the bottom to fit the sprite
			body_collision.position = Vector2(0, OFFSET_COLLISION)


	player_detect.position = pos_vector    #set position for the player detect
	shape.set_size(size_vector)            #set the shape for the new size
	detection_collision.shape = shape      #set the shape of the collision to the new shape

func _process(_delta) -> void:
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

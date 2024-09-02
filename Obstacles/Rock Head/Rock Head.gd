extends Node2D
@onready var animatedSprite: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var playerDetect: Area2D = $AreaDetectPosition/PlayerDetect
@onready var detectionCollision: CollisionShape2D = $AreaDetectPosition/PlayerDetect/DetectionShape
@onready var bodyCollision: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var deathArea: Area2D = $AnimatableBody2D/Death

const BLINK_TIME := 10.0    #blink timer for blink animation
const OFFSET_DETECTION = 40     #offset for player detect area to start at the edge of the rockhead
const OFFSET_COLLISION = 3      #offset for collision shape to fill the sprite of the rockhead
const OFFSET_DEATH = 36         #offset for death area to be at the point where the rockhead is going towards
const WIDTH = 86      #setting up the area to be the size of the path

@export var speed: float = 2

var blink: bool = false
var animation: String    #string to handle the different names of the different hit animatons      

func _ready() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()      #creating a new shape
	#check if theres a curve
	if (!self.curve):
		return
	var pointPos: Vector2 = self.curve.get_point_position(1)   #getting the last point of the path (only using straight lines)
	var sizeVector: Vector2        #size of the detection collision
	
	#position of the detection area
	#detection area's center is the the center of the path line
	#either x or y should always be 0
	var detectionPos :=  Vector2((pointPos.x * 0.5),(pointPos.y * 0.5))
	
	match pointPos.normalized():   #make normalized
		Vector2.RIGHT:
			#set x to absolute of point.x to work with negatives
			#set y to WIDTH 
			sizeVector = Vector2(abs(pointPos.x), WIDTH)
			#get animation    
			animation = "hit right"
			#offset detection area and death area to the right    
			detectionPos.x += OFFSET_DETECTION
			deathArea.position = Vector2(OFFSET_DEATH, 0)    
			#offset collision of body slightly to the left to fit the sprite
			bodyCollision.position = Vector2(-OFFSET_COLLISION, 0)
			#rotating body and death area by 90 degrees when facing left or right
			bodyCollision.rotation_degrees = 90
			deathArea.rotation_degrees = 90
  
		Vector2.LEFT:
			sizeVector = Vector2(abs(pointPos.x), WIDTH)
			animation = "hit left" 
			#offset detection and death area to the left
			detectionPos.x -= OFFSET_DETECTION      
			deathArea.position = Vector2(-OFFSET_DEATH, 0)
			#offset collision of body slightly to the right to fit the sprite
			bodyCollision.position = Vector2(OFFSET_COLLISION, 0)  
			bodyCollision.rotation_degrees = 90
			deathArea.rotation_degrees = 90

		Vector2.DOWN:
			sizeVector = Vector2(WIDTH,abs(pointPos.y))
			animation = "hit bottom"
			#offset detection and death area to the bottom      
			detectionPos.y += OFFSET_DETECTION
			deathArea.position = Vector2(0, OFFSET_DEATH)
			#offset collision of body slightly to the top to fit the sprite
			bodyCollision.position = Vector2(0, -OFFSET_COLLISION)
		Vector2.UP:
			sizeVector = Vector2(WIDTH,abs(pointPos.y))
			animation = "hit top"
			#offset detection and death area to the top    
			detectionPos.y -= OFFSET_DETECTION
			deathArea.position = Vector2(0, -OFFSET_DEATH)
			#offset collision of body slightly to the bottom to fit the sprite
			bodyCollision.position = Vector2(0, OFFSET_COLLISION)

	playerDetect.position = detectionPos    #set position for the player detect
	shape.set_size(sizeVector)            #set the shape for the new size
	detectionCollision.shape = shape      #set the shape of the collision to the new shape

func _process(_delta) -> void:
	if blink:
		return
	blink = true           #cannot blink again before animation is over
	await get_tree().create_timer(BLINK_TIME).timeout    #blink every 10 seconds
	animatedSprite.play("blink")
	await animatedSprite.animation_finished
	animatedSprite.play("idle")
	blink = false            #reset blink so rockhead can blink again in another 10 seconds

func _on_player_detect_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Player"):
		return
	animationPlayer.speed_scale = speed
	animationPlayer.play("fall")
		
func _play_animation():
	animatedSprite.play(animation)

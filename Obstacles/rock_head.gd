extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var find_ground = $FindGround
@onready var find_player: Array = $FindPlayer.get_children() #get all raycasts

var init_pos: Vector2                           #Vector2 variable for the starting position 

const BLINK_TIME := 10.0                        #blink timer for blink animation
var blinking: bool = false                      #is true when rockhead is blinking

const TIMER := 2.0

func _ready():
	init_pos = self.global_position        #set initial posotion to the global position in the scene

func _process(_delta):
	if(false == blinking):
		blinking = true                                      #cannot blink again before animation is over
		await get_tree().create_timer(BLINK_TIME).timeout    #blink every 10 seconds
		animated_sprite.play("blink")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
		blinking = false            #reset blinking so rockhead can blink again in another 10 seconds

func _physics_process(_delta):
	for ray in find_player:                               #go through all player raycasts
		if(ray.is_colliding()):                           #if one is colliding with player
			self.set_deferred("freeze", false)            #unfreeze rockhead to start falling 
	if(find_ground.is_colliding()):                       #if ground raycast is colliding with ground
		on_ground()                                       

#function to handle when body is on ground
func on_ground():
	find_ground.set_deferred("enabled", false)            #disable ground raycast to prevent 
	animated_sprite.play("hit ground")                             #starting the function more than once
	await animated_sprite.animation_finished                       #wait for end of animation
	hitbox.set_deferred("disabled", true)                 #disable hitbox while on ground
	animated_sprite.play("idle")                                   #go back to idle animation
	for ray in find_player:                               #disable all player raycasts
		ray.set_deferred("enabled", false)
	await get_tree().create_timer(TIMER).timeout          #wait 2 seconds
	climb_up()                          

#function to handle the body going up to starting position
func climb_up():
	#create and handle a tween
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", init_pos, 1)
	await tween.finished                                  #wait for tween to finish
	self.set_deferred("freeze", true)                     #freeze body
	hitbox.set_deferred("disabled", false)                #enable hitbox
	for ray in find_player:                               #enable player raycasts
		ray.set_deferred("enabled", true)
	find_ground.set_deferred("enabled", true)             #enable ground raycast
	

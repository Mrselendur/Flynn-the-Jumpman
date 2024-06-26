extends RigidBody2D

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var rock_head = $"."
@onready var find_ground = $FindGround
@onready var find_player: Array = $FindPlayer.get_children() #get all raycasts

var init_pos: Vector2                           #Vector2 variable for the starting position 

const BLINK_TIME = 1000                         #blink timer for blink animation (is subject to change!)
var counter = BLINK_TIME                        #blink counter (is subject to change!)

func _ready():
	init_pos = rock_head.global_position        #set initial posotion to the global position in the scene

func _process(_delta):
	counter -= 1                                #decrease every frame (not good!)
	if(0 == counter):                           #different systems will get different blink times in seconds!
		sprite.play("blink")
		await sprite.animation_finished
		sprite.play("idle")
		counter = BLINK_TIME

func _physics_process(_delta):
	for ray in find_player:                               #go through all player raycasts
		if(ray.is_colliding()):                           #if one is colliding with player
			rock_head.set_deferred("freeze", false)       #unfreeze rockhead to start falling 
	if(find_ground.is_colliding()):                       #if ground raycast is colliding with ground
		on_ground()                                       

#function to handle when body is on ground
func on_ground():
	find_ground.set_deferred("enabled", false)            #disable ground raycast to prevent 
	sprite.play("hit ground")                             #starting the function more times than once
	await sprite.animation_finished                       #wait for end of animation
	hitbox.set_deferred("disabled", true)                 #disable hitbox while on ground
	sprite.play("idle")                                   #go back to idle animation
	for ray in find_player:                               #disable all player raycasts
		ray.set_deferred("enabled", false)
	await get_tree().create_timer(2).timeout              #wait 2 seconds
	climb_up()                          

#function to handle the body going up to starting position
func climb_up():
	#create and handle a tween
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(rock_head, "global_position", init_pos, 1)
	await tween.finished                                  #wait for tween to finish
	rock_head.set_deferred("freeze", true)                #freeze body
	hitbox.set_deferred("disabled", false)                #enable hitbox
	for ray in find_player:                               #enable player raycasts
		ray.set_deferred("enabled", true)
	find_ground.set_deferred("enabled", true)             #enable ground raycast


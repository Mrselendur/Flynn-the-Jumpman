extends CharacterBody2D

const SPEED: float = 400.0             #constant for movement
const JUMP_VELOCITY: float = -400.0    #constant for jumping power
const MAX_JUMPS = 2
const COYOTE_TIME: float = 0.2         #coyote time max seconds
const JUMP_BUFFER_TIME: float = 0.1    #jump buffer max seconds
const FALL_GRAVITY = 2000              #gravity for when player is falling 
const TERMINAL_FALL_VELOCITY = 5600

#state machine for character control, entering scene and exiting scene 
enum state{
	ENTER,
	ACTIVE,
	EXIT,
	DISABLED}

var currentState          #state to reiterate through the state machine

#variables conecting to nodes
@onready var animatedSprite = $AnimatedSprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var collisionShape = $CollisionShape2D
@onready var hitboxCollision = $Hitbox/hitbox_collision

@onready var fx: AudioStream

#jumps
var jumpCount: int = 0
var coyoteCounter: float
var jumpBufferCounter: float

#for particles when double jumping
var emmiting = false

var changeScene: String

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	currentState = state.ENTER #start in enter state

func _physics_process(delta) -> void:
	match currentState:
		state.ENTER:
			animatedSprite.play("appear")
			await animatedSprite.animation_finished
			currentState = state.ACTIVE              #change state to active

		state.ACTIVE:
			#Get the input direction and handle the movement/deceleration.
			#get_axis() returns a -1 value from the first argument and a 1 value from the second
			var direction = Input.get_axis("left", "right")   #returns 0 if neither
			if (0 != direction):                      #player is moving
				velocity.x = direction * SPEED        #move towards inputed direction with speed const
				var isLeft = direction < 0            #if direction is negative set isLeft to true
				animatedSprite.flip_h = isLeft       #flip sprite so character looks where he's going
			else:                                     #player is not moving
				velocity.x = move_toward(velocity.x, 0, SPEED)    #decrease velocity.x to 0 by SPEED amount
			# Handle jump.
			if is_on_floor():
				coyoteCounter = COYOTE_TIME #reset coyote_counter 
				jumpCount = 0
				if(0 < jumpBufferCounter): #if jump buffer hasn't run out - jump
					jump()
				jumpBufferCounter = 0 #reset jump buffer back to zero

				#move down from one-way platform with small collision shapes
				if (Input.is_action_just_pressed("down")):
					position.y += 1
			# Add the gravity (player is not jumping and is not on ground).
			else:  
				velocity.y += _gravity() * delta      #adds gravity player
				#implements terminal velocity
				if velocity.y >= TERMINAL_FALL_VELOCITY:
					velocity.y = TERMINAL_FALL_VELOCITY
				coyoteCounter -= delta        #start counting down coyote counter

			if(Input.is_action_just_pressed("up")):
				jumpBufferCounter = JUMP_BUFFER_TIME     #start jump buffer
				#if coyote timer has run out and hasn't jumped yet OR has jumped twice
				#add one to counter to skip normal jump and player uses up the double jump
				if(0 >= coyoteCounter && jumpCount != 1):
					jumpCount += 1
				#if the timer hasnt run out then the player has a normal and a double jump
				jump()

			else:
				jumpBufferCounter -= delta    #decrease jump buffer when not pressing jump button

			#variable jump hight by releasing jump button early
			if((true == Input.is_action_just_released("up")) && jumpCount == 1):
				velocity.y *= 0.5
			active_animations()
			move_and_slide()

		state.EXIT:                 #play exit animation and end game
			animationPlayer.play("RESET")
			collisionShape.disabled = true                    #disable collision and hitbox 
			hitboxCollision.disabled = true                   #to prevent unnecessary collisions
			animatedSprite.play("disappear")
			velocity.x = 0                                    #disable movement so player doesn't 
			velocity.y = 0                                    #move when exit animation is playing
			await animatedSprite.animation_finished           #wait for end of animation 
			currentState = state.DISABLED                     #before changing scene
			GameManager.setChange(changeScene, "res://Scenes/Levels/" + get_parent().get_parent().name + ".tscn")
 
#function has a parameter with default value:
# - when it's called with 0 arguments it takes the default value as jump power
# - when there is an argument it takes that as its value
func jump(jumpPower: float = JUMP_VELOCITY) -> void:
	if jumpCount >= MAX_JUMPS:
		return                       
	#if player hasn't used up regular and double jump
	fx = preload("res://Free/Audio/Sound Effects/jump.wav")
	AudioHandler.playFX(fx, -20)
	velocity.y = jumpPower     #jump
	jumpCount += 1             #increase the jump count
	jumpBufferCounter = 0      #reset jump buffer	

func _on_area_2d_area_entered(area) -> void:
	#return from function if area is not finish or death
	if(!area.is_in_group("Finish") && !area.is_in_group("Death")):
		return
	elif(area.is_in_group("Finish")):                     #area is in group "Finish"
		fx = preload("res://Free/Audio/Sound Effects/win.wav")
		changeScene = "res://Scenes/Menus/Level Complete.tscn"  #ready scene to change to level complete
	else:             #area is in group "Death"
		fx = preload("res://Free/Audio/Sound Effects/death.wav")
		changeScene = "res://Scenes/Menus/Game Over.tscn"       #ready scene to change to game over
	AudioHandler.playFX(fx, -10)
	currentState = state.EXIT                            #change state to exit

#when player is jumping - returns the default gravity from the project settings
#when player is falling - returns the fall gravity to exaggerate the fall 
func _gravity() -> float:
	if velocity.y > 0:
		return FALL_GRAVITY
	return gravity

func active_animations():
	if is_on_floor():
		emmiting = false           #allows for another particle emission
		if velocity.x != 0:                       #if moving in any direction
			animatedSprite.play("running")       #change animation to running 
		else:                                     #if standing still
			animatedSprite.play("idle")       #play idle sprite animation
	else:
		if velocity.y >= 0:
			animatedSprite.play("falling")
		else:
			if jumpCount == 2:
				animatedSprite.play("double jump")
				make_particles()

			animationPlayer.play("jumping")
			
#instantiates a particle scene and adds it as a child to Player
func make_particles() -> void:
	if emmiting:       #check if already emmiting
		return
	emmiting = true    #makes sure particles dont emmit again before landing
	var inst : CPUParticles2D = preload("res://Player/Jump Particles.tscn").instantiate()
	add_child(inst)

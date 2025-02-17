extends CharacterBody2D

const SPEED: float = 400.0             #constant for movement
const JUMP_VELOCITY: float = -400.0    #constant for jumping power
const MAX_JUMPS: int = 2
const COYOTE_TIME: float = 0.1         #coyote time max seconds
const JUMP_BUFFER_TIME: float = 0.1    #jump buffer max seconds
const FALL_GRAVITY: float = 2000              #gravity for when player is falling 
const TERMINAL_FALL_VELOCITY: float = 5600

#state machine for character control, entering scene and exiting scene 
enum state{
	ENTER,
	ACTIVE,
	EXIT}

@onready var currentState: int = state.ENTER         #state to reiterate through the state machine

#variables connecting to nodes

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var hitboxCollision: CollisionShape2D = $Hitbox/HitboxCollision

@onready var fx: AudioStream

#jumps
var jumpCount: int = 0
var coyoteCounter: float
var jumpBufferCounter: float

#for particles when double jumping
var emitting: bool = false

var changeScene: String

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta) -> void:
	match currentState:
		state.ENTER:
			animatedSprite.play("appear")
			await animatedSprite.animation_finished
			currentState = state.ACTIVE              

		state.ACTIVE:
			#Get the input direction and handle the movement/deceleration.
			#get_axis() returns a -1 value from the first argument and a 1 value from the second
			var direction: float = Input.get_axis("left", "right")   #returns 0 if neither
			if (0 != direction):                      #player is moving
				velocity.x = direction * SPEED        #move towards inputed direction with speed const
				var isLeft: bool = direction < 0      #if direction is negative set isLeft to true
				animatedSprite.flip_h = isLeft       #flip sprite so character looks where he's going
			else:                                     #player is not moving
				velocity.x = move_toward(velocity.x, 0, SPEED)    #decrease velocity.x to 0 by SPEED amount
			
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
			# Handle jump.
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
			if(Input.is_action_just_released("up") && jumpCount == 1):
				velocity.y *= 0.5
			active_animations()
			move_and_slide()
			
		#play exit animation and end game
		state.EXIT:  
			set_physics_process(false)              
			animationPlayer.play("RESET")
			collisionShape.disabled = true      
			hitboxCollision.disabled = true  
			animatedSprite.play("disappear")
			velocity = Vector2i(0,0)
			await animatedSprite.animation_finished      
			GameManager.set_change(changeScene)

#function has a parameter with default value:
# - when it's called with 0 arguments it takes the default value as jump power
# - when there is an argument it takes that as its value
func jump(jumpPower: float = JUMP_VELOCITY) -> void:
	if jumpCount >= MAX_JUMPS:
		return
   
	#if player hasn't used up regular and double jump
	fx = preload("res://Free/Audio/Sound Effects/jump.wav")
	AudioHandler.play_fx(fx, -20)
	velocity.y = jumpPower     #jump
	jumpCount += 1             #increase the jump count
	jumpBufferCounter = 0      #reset jump buffer

func _on_area_2d_area_entered(area) -> void:
	#return from function if area is not finish or death
	if(!area.is_in_group("Finish") && !area.is_in_group("Death")):
		return
	elif(area.is_in_group("Finish")):             
		#ready scene to change to level complete
		fx = preload("res://Free/Audio/Sound Effects/win.wav")
		changeScene = "res://Scenes/Menus/Level Complete.tscn"  
	else:
		#ready scene to change to game over
		fx = preload("res://Free/Audio/Sound Effects/death.wav")
		changeScene = "res://Scenes/Menus/Game Over.tscn"       
	AudioHandler.play_fx(fx, -10)
	currentState = state.EXIT     #change state to exit

#when player is jumping - returns the default gravity from the project settings
#when player is falling - returns the fall gravity to exaggerate the fall 
func _gravity() -> float:
	if velocity.y > 0:
		return FALL_GRAVITY
	return gravity

func active_animations() -> void:
	if is_on_floor():
		emitting = false           #allows for another particle emission
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
	if emitting:       #check if already emmiting
		return
	emitting = true    #makes sure particles dont emmit again before landing
	var inst: CPUParticles2D = preload("res://Player/Jump Particles.tscn").instantiate()
	add_child(inst)

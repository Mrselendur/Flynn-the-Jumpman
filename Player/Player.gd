extends CharacterBody2D

const SPEED: float = 400.0             #constant for movement
const JUMP_VELOCITY: float = -400.0    #constant for jumping power
const COYOTE_TIME: float = 0.2         #coyote time max seconds
const JUMP_BUFFER_TIME: float = 0.1    #jump buffer max seconds
const FALL_GRAVITY = 2000              #gravity for when player is falling 

#state machine for character control, entering scene and exiting scene 
enum state{
	ENTER,
	ACTIVE,
	EXIT,
	DISABLED}

var current_state          #state to reiterate through the state machine

#variables conecting to nodes
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox_collision = $Hitbox/hitbox_collision

@onready var fx: AudioStream

#jumps
var jump_count: int = 0
var coyote_counter: float
var jump_buffer_counter: float

var emmiting = false       #for particles when double jumping

var change_scene: String

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_state = state.ENTER #start in enter state

func _physics_process(delta) -> void:
	match current_state:
		state.ENTER:
			#await SceneTransition.transition_finished
			animated_sprite.play("appear")
			await animated_sprite.animation_finished
			current_state = state.ACTIVE              #change state to active

		state.ACTIVE:
			#Get the input direction and handle the movement/deceleration.
			#get_axis() returns a -1 value from the first argument and a 1 value from the second
			var direction = Input.get_axis("left", "right")   #returns 0 if neither
			if (0 != direction):                      #player is moving
				velocity.x = direction * SPEED        #move towards inputed direction with speed const
				var isLeft = direction < 0            #if direction is negative set isLeft to true
				animated_sprite.flip_h = isLeft       #flip sprite so character looks where he's going
			else:                                     #player is not moving
				velocity.x = move_toward(velocity.x, 0, SPEED)    #decrease velocity.x to 0 by SPEED amount
			#print(coyote_counter)
			# Handle jump.
			if is_on_floor():
				coyote_counter = COYOTE_TIME #reset coyote_counter 
				jump_count = 0
				if(0 < jump_buffer_counter): #if jump buffer hasn't run out - jump
					jump()
				jump_buffer_counter = 0 #reset jump buffer back to zero

				#move down from one-way platform with small collision shapes
				if (Input.is_action_just_pressed("down")):
					position.y += 1
			# Add the gravity (player is not jumping and is not on ground).
			else:  
				velocity.y += _gravity() * delta      #adds gravity player
				#if velocity.y > 0:                 #check if player is falling before starting coyote counter
				coyote_counter -= delta        #start counting down coyote counter

			if(Input.is_action_just_pressed("up")):
				jump_buffer_counter = JUMP_BUFFER_TIME     #start jump buffer
				#if coyote timer has run out and hasn't jumped yet OR has jumped twice
				#add one to counter to skip normal jump and player uses up the double jump
				if(0 >= coyote_counter && jump_count != 1):
					jump_count += 1           
				#if the timer hasnt run out then the player has a normal and a double jump
				jump()

			else:
				jump_buffer_counter -= delta    #decrease jump buffer when not pressing jump button

			#variable jump hight by releasing jump button early
			if((true == Input.is_action_just_released("up")) && jump_count == 1):
				velocity.y *= 0.5

			active_animations()
			move_and_slide()

		state.EXIT:                 #play exit animation and end game
			animation_player.play("RESET")
			collision_shape_2d.set_deferred("disabled", true)  #disable collision and hitbox 
			hitbox_collision.set_deferred("disabled", true)    #to prevent unnecessary collisions
			animated_sprite.play("disappear")
			velocity.x = 0                                     #disable movement so player doesn't 
			velocity.y = 0                                     #move when exit animation is playing
			await animated_sprite.animation_finished           #wait for end of animation
			current_state = state.DISABLED
			GameManager.setChange(change_scene)                #before changing scene
 

#function has a parameter with default value:
# - when it's called with 0 arguments it takes the default value as jump power
# - when there is an argument it takes that as its value
func jump(jump_power: float = JUMP_VELOCITY):
	if jump_count >= 2:
		return                       

	#if player hasn't used up regular and double jump
	fx = preload("res://Free/Audio/jump.wav")
	AudioHandler.playFX(fx, -20)
	velocity.y = jump_power              #jump
	jump_count += 1                      #increase the jump count
	jump_buffer_counter = 0              #reset jump buffer	

func _on_area_2d_area_entered(area) -> void:
	#return from function if area is not finish or death
	if(!area.is_in_group("Finish") && !area.is_in_group("Death")):
		return
	elif(area.is_in_group("Finish")):                     #area is in group "Finish"
		fx = preload("res://Free/Audio/win.wav")
		change_scene = "res://Scene/Level Complete.tscn"  #ready scene to change to level complete
	else:             #area is in group "Death"
		fx = preload("res://Free/Audio/089684_retro-you-lose-sfx-85557.wav")
		AudioHandler.playFX(fx,-20)
		fx = preload("res://Free/Audio/death.wav")
		change_scene = "res://Scene/Game Over.tscn"       #ready scene to change to game over
	AudioHandler.playFX(fx, -5)
	current_state = state.EXIT                            #change state to exit

#when player is jumping - returns the default gravity from the project settings
#when player is falling - returns the fall gravity to exaggerate the fall 
func _gravity():
	if velocity.y > 0:
		return FALL_GRAVITY
	return gravity

func active_animations():
	if is_on_floor():
		emmiting = false           #allows for another particle emission
		if velocity.x != 0:                       #if moving in any direction
			animated_sprite.play("running")       #change animation to running 
		else:                                     #if standing still
			animated_sprite.play("idle")       #play idle sprite animation
	else:
		match jump_count:
			1:
				animation_player.play("jumping")
			2:
				animated_sprite.play("double jump")
				make_particles()
			_:
				animated_sprite.play("jumping")

#instantiates a particle scene and adds it as a child to Player
func make_particles() -> void:
		if emmiting:       #check if already emmiting
			return
		emmiting = true    #makes sure particles dont emmit again before landing
		var inst = preload("res://Player/Jump_Particles.tscn").instantiate()
		add_child(inst)

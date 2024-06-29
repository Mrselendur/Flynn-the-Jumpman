extends CharacterBody2D

const SPEED: float = 400.0             #constant for movement
const JUMP_VELOCITY: float = -400.0    #constant for jumping power
const COYOTE_TIME: float = 0.2         #coyote time max seconds
const JUMP_BUFFER_TIME: float = 0.1    #jump buffer max seconds
const FALL_GRAVITY = 1500              #gravity for when player is falling 

#state machine for character control, entering scene and exiting scene 
enum state{
	ENTER,
	ACTIVE,
	EXIT}

var current_state          #state to reiterate through the state machine

#variables conecting to nodes
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox_collision = $Hitbox/hitbox_collision
@onready var cpu_particles = $CPUParticles2D

#jumps
var jump_count: int = 0
var coyote_counter: float
var jump_buffer_counter: float


var change_scene: String

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_state = state.ENTER #start in enter state

func _physics_process(delta) -> void:
	match current_state:
		state.ENTER:
			animated_sprite.play("appear")
			await(animated_sprite.animation_finished)
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
				velocity.y += get_gravity(velocity.y) * delta      #adds gravity player
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

		state.EXIT:                 #play exit animation and end game
			animation_player.play("RESET")
			collision_shape_2d.set_deferred("disabled", true)  #disable collision and hitbox 
			hitbox_collision.set_deferred("disabled", true)    #to prevent unnecessary collisions
			animated_sprite.play("disappear")
			velocity.x = 0                                     #disable movement so player doesn't 
			velocity.y = 0                                     #move when exit animation is playing
			await animated_sprite.animation_finished           #wait for end of animation 
			GameManager.setChange(change_scene)                #before changing scene 
			
	move_and_slide()

#function has a parameter with default value:
# - when it's called with 0 arguments it takes the default value as jump power
# - when there is an argument it takes that as its value
func jump(jump_power: float = JUMP_VELOCITY):
	if jump_count < 2:                       #if player hasn't used up regular and double jump
		velocity.y = jump_power              #jump
		jump_count += 1                      #increase the jump count
		print(jump_count)
		jump_buffer_counter = 0              #reset jump buffer

func _on_area_2d_area_entered(area) -> void:
	#return from function if area is not finish or death
	if(!area.is_in_group("Finish") && !area.is_in_group("Death")):
		return
	elif(area.is_in_group("Finish")):                     #area is in group "Finish"
		change_scene = "res://Scene/Level Complete.tscn"  #ready scene to change to level complete
	else:                                                 #area is in group "Death"
		change_scene = "res://Scene/Game Over.tscn"       #ready scene to change to game over

	current_state = state.EXIT                            #change state to exit

#when player is jumping - returns the default gravity from the project settings
#when player is falling - returns the fall gravity to exaggerate the fall 
func get_gravity(velocity_y: float):
	if velocity_y > 0:
		return FALL_GRAVITY
	return gravity

func active_animations():
	if is_on_floor():
		if velocity.x != 0:                       #if moving in any direction
			animated_sprite.play("running")       #change animation to running 
		else:                                     #if standing still
			animated_sprite.play("default")       #play idle sprite animation
	else:
		#if jump_count < 2:
			#animated_sprite.play("jumping")
			#animation_player.p
		#else:
			#animated_sprite.play("double jump")
		#print(jump_count)
		match jump_count:
			1:
				#animated_sprite.play("jumping")
				animation_player.play("jumping")
			2:
				cpu_particles.emitting = true
				animated_sprite.play("double jump")
				await get_tree().create_timer(0.5).timeout
				cpu_particles.emitting = false
			_:
				animated_sprite.play("jumping")

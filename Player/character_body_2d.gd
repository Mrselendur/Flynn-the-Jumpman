extends CharacterBody2D

const SPEED: float = 400.0             #constant for movement
const JUMP_VELOCITY: float = -400.0    #constant for jumping power
const COYOTE_TIME: float = 0.1         #coyote time max seconds
const JUMP_BUFFER_TIME: float = 0.1    #jump buffer max seconds

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

#jumps
var jump: bool = false
var coyote_counter: float = 0.0
var jump_buffer_counter: float = 0.0

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
			current_state = state.ACTIVE #change state to active
		state.ACTIVE:
			#Get the input direction and handle the movement/deceleration.
			#get_axis() returns a -1 value from the first argument and a 1 value from the second 
			var direction = Input.get_axis("left", "right")   #returns 0 if neither
			if (0 != direction):                      #player is moving
				velocity.x = direction * SPEED        #move towards inputed direction with speed const
				animated_sprite.play("running")       #change animation to running 
				var isLeft = direction < 0            #if direction is negative set isLeft to true
				animated_sprite.flip_h = isLeft       #flip sprite so character looks where he's going
			else:                                     #player is not moving
				velocity.x = move_toward(velocity.x, 0, SPEED)    #decrease velocity.x to 0 by SPEED amount
				animated_sprite.play("default")       #play idle sprite animation

			# Handle jump.
			if (true == is_on_floor()):
				if(0 < jump_buffer_counter): #if jump_buffer hasn't run out - jump
					velocity.y = JUMP_VELOCITY
					jump = true
 
				else:
					coyote_counter = COYOTE_TIME #reset coyote_counter 
					jump = false

				jump_buffer_counter = 0 #reset jump buffer back to zero

				#move down from one-way platform with small collision shapes
				if (Input.is_action_just_pressed("down")): 
					position.y += 1


			# Add the gravity (player is not jumping and is not on ground).
			else:       
				animated_sprite.play("jumping")     #change sprite to jumping
				velocity.y += gravity * delta       #adds grivity to velocity.y
				coyote_counter -= delta             #start counting down coyote counter

			if(Input.is_action_just_pressed("up")):
				jump_buffer_counter = JUMP_BUFFER_TIME     #start jump buffer

				if((0 < coyote_counter) && (false == jump)):    #coyote timer still has time
					animation_player.play("jumping")            #and player hasn't jumped yet
					velocity.y = JUMP_VELOCITY                  #jump
					jump_buffer_counter = 0                     #reset jump buffer
					jump = true                           #preventing player from jumping infinitely

			else:
				jump_buffer_counter -= delta      #decrease jump buffer when not pressing jump button

			#variable jump hight by releasing jump button early
			if((true == Input.is_action_just_released("up"))):
				velocity.y *= 0.5

		state.EXIT:
			animation_player.play("RESET")
			collision_shape_2d.set_deferred("disabled", true)  #disable collision and hitbox 
			hitbox_collision.set_deferred("disabled", true)    #to prevent unnecessary collisions
			animated_sprite.play("disappear")
			velocity.x = 0                                     #disable movement so player doesn't 
			velocity.y = 0                                     #move when exit animation is playing
			await animated_sprite.animation_finished           #wait for end of animation 
			GameManager.setChange(change_scene)                #before changing scene 
			
	move_and_slide()

func _on_area_2d_area_entered(area) -> void:
	#return from function if area is not finish or death
	if(!area.is_in_group("Finish") && !area.is_in_group("Death")):
		return
	elif(area.is_in_group("Finish")):                     #area is in group "Finish"
		change_scene = "res://Scene/Level Complete.tscn"  #ready scene to change to level complete
	else:                                                 #area is in group "Death"
		change_scene = "res://Scene/Game Over.tscn"       #ready scene to change to game over

	current_state = state.EXIT                            #change state to exit

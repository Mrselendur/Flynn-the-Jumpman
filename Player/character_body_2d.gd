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
			# Get the input direction and handle the movement/deceleration.
			# get_axis() returns a negative value from the first argument and a positive value from the second
			var direction = Input.get_axis("left", "right")
			if (0 != direction):
				velocity.x = direction * SPEED
				animated_sprite.play("running")
				#if direction is negative set isLeft to true
				var isLeft = direction < 0
				animated_sprite.flip_h = isLeft
			else:
				#stop movement
				velocity.x = move_toward(velocity.x, 0, SPEED)
				animated_sprite.play("default")

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


			# Add the gravity.
			else:
				animated_sprite.play("jumping")
				velocity.y += gravity * delta
				coyote_counter -= delta 

			if(Input.is_action_just_pressed("up")):
				jump_buffer_counter = JUMP_BUFFER_TIME #start jump buffer

				if((0 < coyote_counter) && (false == jump)):
					animation_player.play("jumping")
					velocity.y = JUMP_VELOCITY
					jump_buffer_counter = 0
					jump = true

			else:
				jump_buffer_counter -= delta

			if((true == Input.is_action_just_released("up"))):
				velocity.y *= 0.5

		state.EXIT:
			collision_shape_2d.set_deferred("disabled", true)  #disable collision and hitbox 
			hitbox_collision.set_deferred("disabled", true)    #to prevent unnecessary collisions
			animated_sprite.play("disappear")
			velocity.x = 0                                     #disable movement so character doesn' move
			velocity.y = 0                                     #when exit animation is playing
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

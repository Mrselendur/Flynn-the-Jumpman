extends CharacterBody2D

const SPEED: float = 400.0
const JUMP_VELOCITY: float = -400.0
const COYOTE_TIME: float = 0.2
const JUMP_BUFFER_TIME: float = 0.1

enum state{
	ENTER,
	ACTIVE,
	EXIT}

var current_state

@onready var sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox_collision = $Hitbox/hitbox_collision

@export var target_level : PackedScene


#jumps
var jump: bool = false
var coyote_counter: float = 0.0
var jump_buffer_counter: float = 0.0

var change_scene: String

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_state = state.ENTER

func _physics_process(delta) -> void:
	match current_state:
		state.ENTER:
			sprite_2d.play("appear")
			await(sprite_2d.animation_finished)
			current_state = state.ACTIVE
		state.ACTIVE:
			# Get the input direction and handle the movement/deceleration.
			# get_axis() returns a negative value from the first argument and a positive value from the second
			var direction = Input.get_axis("left", "right")
			if (0 != direction):
				velocity.x = direction * SPEED
				sprite_2d.play("running")
				#if direction is negative set isLeft to true
				var isLeft = direction < 0
				sprite_2d.flip_h = isLeft
			else:
				#stop movement
				velocity.x = move_toward(velocity.x, 0, SPEED)
				sprite_2d.play("default")

			# Handle jump.
			if (true == is_on_floor()):
				if(0 < jump_buffer_counter):
					velocity.y = JUMP_VELOCITY
					jump = true
					jump_buffer_counter = 0
				else:
					coyote_counter = COYOTE_TIME
					jump = false
					jump_buffer_counter = 0

			# Add the gravity.
			else:
				sprite_2d.play("jumping")
				velocity.y += gravity * delta
				coyote_counter -= delta
				
			if (Input.is_action_just_pressed("down") && is_on_floor()):
				position.y += 1

			if(Input.is_action_just_pressed("up")):
				jump_buffer_counter = JUMP_BUFFER_TIME

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
			collision_shape_2d.set_deferred("disabled", true)
			hitbox_collision.set_deferred("disabled", true)
			sprite_2d.play("disappear")
			velocity.x = 0
			velocity.y = 0
			await sprite_2d.animation_finished
			GameManager.setChange(change_scene)
	move_and_slide()

func _on_area_2d_area_entered(area) -> void:
	if(!area.is_in_group("Finish") && !area.is_in_group("Death")):
		return
	elif(area.is_in_group("Finish")):
		change_scene = "res://Scene/Level Complete.tscn" 
	#area is in group "Death"
	else:
		change_scene = "res://Scene/Game Over.tscn"

	current_state = state.EXIT

extends RigidBody2D

const SPEED := 250.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _integrate_forces(state):
	#state.set_linear_velocity(SPEED)
	#await get_tree().create_timer(2).timeout
	#state.set_linear_velocity(-SPEED)

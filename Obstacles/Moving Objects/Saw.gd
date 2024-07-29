extends "Moving Object.gd"

@export var isLooped: bool = false          #path is closed or not
@export var loopSpeed: float = 250         #for closed paths

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#play animataion for an open path with speed scale determening the speed of the object
	spritePath = "res://Free/Traps/Saw/Chain.png"
	super()
	if isLooped:
		return
	animationPlayer.speed_scale = openSpeed
	animationPlayer.play("on")
	set_process(false)         #turn off _process function	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	objectPath.progress += loopSpeed * delta

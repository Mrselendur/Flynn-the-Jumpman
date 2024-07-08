extends Path2D

@export var loop: bool = false          #path is closed or not
@export var speed_scale:float = 1       #for open paths
@export var speed: float = 250         #for closed paths

@onready var saw: Path2D = $"."
@onready var path: Node2D = $Path   #path is a node where all sprites will be located
@onready var saw_path: PathFollow2D = $SawPath   #needed for speed if path is closed
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPRITE_DISTANCE = 10     #the distance between every sprite in px

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#play animataion for an open path with speed scale determening the speed of the saw
	if not loop:
		animation_player.speed_scale = speed_scale
		animation_player.play("on")
		set_process(false)         #turn off _process function
	
	#checks if there's a curve - if not the saw is just going to stay idle, only the sprite is moving
	if !saw.curve:
		return

	#an array of sprites
	var sprite_array: Array[Sprite2D] = []
	#load the filepath to the texure used for path
	var path_texture := load("res://Free/Traps/Saw/Chain.png")
	#get the number of points in the curve
	var point_count = saw.curve.point_count
	#loop through n-1 times because it's checking for the current curve and the next one
	for i in point_count-1:
		#store the vectors of the points in variables
		var point_pos_current = saw.curve.get_point_position(i)
		var point_pos_next = saw.curve.get_point_position(i+1)
		#get the distance between the points
		var distance = point_pos_current.distance_to(point_pos_next)
		#get how many sprites it's going to use (1 for every 10 px)
		var sprite_count:int = distance/SPRITE_DISTANCE
		#loop through all sprites
		for j in sprite_count:
			#fill the array with a sprite
			sprite_array.insert(j, Sprite2D.new())
			#make the node "path" a parent to all sprites (optional)
			path.add_child(sprite_array[j])
			#set the texture of the sprites
			sprite_array[j].set_texture(path_texture)
			#move the sprite every loop by 10*j (first loop 0, second loop 10, thrid loop 20 ect)
			sprite_array[j].position = point_pos_current.move_toward(point_pos_next, SPRITE_DISTANCE*j)

func _process(delta: float) -> void:
	saw_path.progress += speed * delta

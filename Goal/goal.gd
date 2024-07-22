extends Area2D

@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

@export var required_points: int    #points needed to complete level

var is_shown: bool = false          #variable to check if goal has been shown

func _ready() -> void:
	sprite.visible = false

#check every frame for a shown goal and if player has collected required points
func _process(_delta) -> void:
	var points: int = GameManager.getLevelPoints()
	if is_shown || points < required_points: 
		if label:
			label.text = "Need " + str(required_points - points) + " more points!"
		return
	label.queue_free()
	self.monitorable = true         #make the goal monitorable
	sprite.visible = true           #make the goal visible
	is_shown = true                 #remove the need for the code to execute again

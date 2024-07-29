extends Area2D

@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

@export var requiredPoints: int    #points needed to complete level

var isShown: bool = false          #variable to check if goal has been shown

func _ready() -> void:
	sprite.visible = false

#check every frame for a shown goal and if player has collected required points
func _process(_delta) -> void:
	var points: int = GameManager.getLevelPoints()
	if isShown || points < requiredPoints: 
		if label:
			label.text = "Need " + str(requiredPoints - points) + " more points!"
		return
	label.queue_free()
	self.monitorable = true         #make the goal monitorable
	sprite.visible = true           #make the goal visible
	isShown = true                 #remove the need for the code to execute again

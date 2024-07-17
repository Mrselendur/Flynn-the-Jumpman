extends Area2D

@export var required_points: int    #points needed to progress

var is_shown: bool = false          #variable to check if goal has been shown

func _ready() -> void:
	self.visible = false

#check every frame for a shown goal and if player has collected required points
func _process(_delta) -> void:
	if  is_shown || required_points > GameManager.getLevelPoints():
		return
	self.monitorable = true         #make the goal monitorable
	self.visible = true             #make the goal visible
	is_shown = true                 #remove the need for the code to execute again

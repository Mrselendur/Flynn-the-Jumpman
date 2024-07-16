extends Area2D

@export var required_points: int    #points needed to progress

var is_shown: bool = false          #variable to check if goal has been shown

func _ready() -> void:
	self.visible = false

#check every frame for a shown goal and if player has collected required points
func _process(_delta):
	if((false == is_shown) && (required_points <= GameManager.getLevelPoints())):
		self.set_deferred("monitorable", true)          #turn on monitorable property
		self.set_deferred("visible", true)              #turn on visible property
		is_shown = true            #set is_shown to true to never enter the if statement agian

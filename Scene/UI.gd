extends CanvasLayer

@onready var points_label = %PointsLabel

func _process(_delta):
	points_label.text = str(GameManager.getLevelPoints())

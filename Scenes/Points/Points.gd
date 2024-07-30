extends Panel

func _process(_delta):
	$PointsLabel.text = str(GameManager.get_level_points())

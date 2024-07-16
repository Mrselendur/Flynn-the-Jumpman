extends Panel

func _process(_delta):
	$PointsLabel.text = str(GameManager.getLevelPoints())

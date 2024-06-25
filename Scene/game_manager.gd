extends Node

var _level_points: int = 0
var _all_points: int = 0
var _changeScene: bool = false
var _targetScene: String

func _process(_delta) -> void:
	if(true == _changeScene):
		changeScene()

func quitGame()->void:
	get_tree().quit()

func setChange(target: String) -> void:
	_changeScene = true
	_targetScene = target

func changeScene() -> void:
	_changeScene = false
	resetLevelPoints()
	get_tree().change_scene_to_file(_targetScene)

func addPoints(points: int) -> void:
	_level_points += points
	_all_points += points

func resetLevelPoints() -> void:
	_level_points = 0

func resetAllPoints() -> void:
	_all_points = 0
	
func getLevelPoints() -> int:
	return _level_points

func getAllPoints() -> int:
	return _all_points

extends Node

var _level_points: int = 0        #points in a single level
var _all_points: int = 0          #points accross all levels in a signle session
var _targetScene: String          #path to the target scene

#quit the game
func quitGame()->void:
	get_tree().quit()

#set up the change of a scene
func setChange(target: String, transition_speed: float = 1) -> void:
	_targetScene = target
	SceneTransition.play_transition(transition_speed)

func _changeScene() -> void:
	resetLevelPoints()
	get_tree().change_scene_to_file(_targetScene)

#adds points to score
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

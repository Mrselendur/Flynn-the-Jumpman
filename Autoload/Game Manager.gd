extends Node

var _levelPoints: int = 0        #points in a single level
var _allPoints: int = 0          #points accross all levels in a signle session
var _targetScene: String          #path to the target scene
var currentLevel: String

#quit the game
func quitGame()->void:
	AudioHandler.playMusic(null)
	get_tree().quit()

#set up the change of a scene
func setChange(target: String, current: String = "", transition_speed: float = 1) -> void:
	if SceneTransition.animationPlayer.is_playing():
		return
	currentLevel = current
	_targetScene = target
	SceneTransition.play_transition(transition_speed)

func _changeScene() -> void:
	resetLevelPoints()
	get_tree().change_scene_to_file(_targetScene)

#adds points to score
func addPoints(points: int) -> void:
	_levelPoints += points
	_allPoints += points

func resetLevelPoints() -> void:
	_levelPoints = 0

func resetAllPoints() -> void:
	_allPoints = 0

func getLevelPoints() -> int:
	return _levelPoints

func getAllPoints() -> int:
	return _allPoints

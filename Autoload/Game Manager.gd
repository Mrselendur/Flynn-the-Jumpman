extends Node

var _levelPoints: int = 0        #points in a single level
var _allPoints: int = 0          #points accross all levels in a signle session
var _targetScene: String         #path to the target scene
var _currentLevel: String        #path to current scene


#quit the game
func quit_game()->void:
	AudioHandler.stop_music()
	get_tree().quit()

#set up the change of a scene
func set_change(target: String, transition_speed: float = 1) -> void:
	if SceneTransition.animationPlayer.is_playing():
		return
	_targetScene = target
	SceneTransition.play_transition(transition_speed)

func _change_scene() -> void:
	get_tree().change_scene_to_file(_targetScene)

func set_current_level(current: String) -> void:
	_currentLevel = current

func get_current_level() -> String:
	return _currentLevel

#adds points to score
func add_level_points(points: int) -> void:
	_levelPoints += points

func add_all_points() -> void:
	_allPoints += _levelPoints

func reset_level_points() -> void:
	_levelPoints = 0

func reset_all_points() -> void:
	_allPoints = 0

func get_level_points() -> int:
	return _levelPoints

func get_all_points() -> int:
	return _allPoints

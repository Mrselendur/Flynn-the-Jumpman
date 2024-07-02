extends Node

func _on_start_pressed() -> void:
	GameManager.setChange("res://Scene/level1.tscn")

func _on_level_select_pressed() -> void:
	GameManager.setChange("res://Scene/Level Select.tscn")

func _on_quit_pressed() -> void:
	GameManager.quitGame()

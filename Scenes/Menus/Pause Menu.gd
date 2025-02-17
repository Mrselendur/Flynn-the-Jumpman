extends Control

@onready var pauseMenu: Control = $"."
@onready var resumeButton: Button = $PanelContainer/VBoxContainer/Resume
@onready var restartButton: Button = $PanelContainer/VBoxContainer/Restart
@onready var menuButton: Button = $PanelContainer/VBoxContainer/Menu

@onready var tree: SceneTree = get_tree()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		esc_pressed()

func pause() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	self.visible = true
	tree.paused = true
	resumeButton.grab_focus()

func resume() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	self.visible = false
	tree.paused = false

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	GameManager.reset_level_points()
	SceneTransition.play_transition(1.5)
	tree.reload_current_scene()

func _on_back_to_menu_pressed() -> void:
	resume()
	GameManager.reset_all_points()
	GameManager.set_change("res://Scenes/Menus/Main Menu.tscn")

func esc_pressed() -> void:
	if tree.paused:
		resume()
	else:
		pause()

#functions for highlighting buttons
func _on_resume_mouse_entered() -> void:
	resumeButton.grab_focus()

func _on_restart_mouse_entered() -> void:
	restartButton.grab_focus()

func _on_back_to_menu_mouse_entered() -> void:
	menuButton.grab_focus()

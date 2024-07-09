extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal transition_finished

func _ready() -> void:
	transition_finished.connect(GameManager._changeScene)

func play_transition(speed_scale:float) -> void:
	animation_player.speed_scale = speed_scale
	animation_player.play("Fade")
	await animation_player.animation_finished
	emit_signal("transition_finished")

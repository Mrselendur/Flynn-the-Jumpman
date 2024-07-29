extends CanvasLayer

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

signal transition_finished

func _ready() -> void:
	transition_finished.connect(GameManager._changeScene)

func play_transition(speedScale:float) -> void:
	animationPlayer.speed_scale = speedScale
	animationPlayer.play("Fade_in")
	await animationPlayer.animation_finished
	emit_signal("transition_finished")
	animationPlayer.play("Fade_out")

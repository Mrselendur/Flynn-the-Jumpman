extends RigidBody2D

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var rock_head = $"."
@onready var find_ground = $FindGround
@onready var find_player = $FindPlayer.get_children()

var init_pos: Vector2

const BLINK_TIME = 1000
var counter = BLINK_TIME

func _ready():
	init_pos = rock_head.global_position

func _process(_delta):
	counter -= 1
	if(0 == counter):
		sprite.play("blink")
		await sprite.animation_finished
		sprite.play("idle")
		counter = BLINK_TIME

func _physics_process(_delta):
	for ray in find_player:
		if(ray.is_colliding()):
			rock_head.set_deferred("freeze", false)
	if(find_ground.is_colliding()):
		find_ground.set_deferred("enabled", false)
		sprite.play("hit ground")
		await sprite.animation_finished
		on_ground()

func on_ground():
	hitbox.set_deferred("disabled", true)
	sprite.play("idle")
	for ray in find_player:
		ray.set_deferred("enabled", false)
	await get_tree().create_timer(2).timeout
	climb_up()

func climb_up():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(rock_head, "global_position", init_pos, 1)
	await tween.finished
	rock_head.set_deferred("freeze", true)
	hitbox.set_deferred("disabled", false)
	for ray in find_player:
		ray.set_deferred("enabled", true)
	find_ground.set_deferred("enabled", true)


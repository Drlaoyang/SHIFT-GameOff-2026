extends CharacterBody2D

@export var speed: float = 60.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var facing: Vector2 = Vector2.DOWN
var is_nb: bool = false


func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	move_and_slide()
	_update_animation(input_dir)


func _update_animation(input_dir: Vector2) -> void:
	if input_dir != Vector2.ZERO:
		if not is_zero_approx(input_dir.x):
			facing = Vector2(signf(input_dir.x), 0.0)
		else:
			facing = Vector2(0.0, signf(input_dir.y))
		var anim := _current_anim()
		if not sprite.is_playing() or sprite.animation != anim:
			sprite.play(anim)
	else:
		var anim := _current_anim()
		if sprite.animation != anim:
			sprite.animation = anim
		if sprite.is_playing():
			sprite.stop()
		sprite.frame = 0


func _current_anim() -> StringName:
	match facing:
		Vector2.UP:
			return &"goup_NB" if is_nb else &"goup"
		Vector2.LEFT:
			return &"goleft_NB" if is_nb else &"goleft"
		Vector2.RIGHT:
			return &"goright_NB" if is_nb else &"goright"
		_:
			return &"godown_NB" if is_nb else &"godown"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SHIFT:
		is_nb = not is_nb

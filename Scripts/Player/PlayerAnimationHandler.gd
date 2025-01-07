extends AnimatedSprite2D
@export var movement : Movement 
var current_animation
var angle = 6

func _process(_delta: float) -> void:
	current_animation = "idle"
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir.length() != 0:
		angle = input_dir.angle() / (PI/4)
		angle = wrapi(int(angle), 0, 8)
		current_animation = "run"
	play(current_animation + str(angle))

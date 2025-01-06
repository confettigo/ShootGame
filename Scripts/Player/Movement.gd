extends CharacterBody2D
class_name Movement

@export var baseSpeed = 50
@export var runSpeed = 300
var currentSpeed = baseSpeed
enum Movements {UP, DOWN}
var direction : Movements = Movements.UP
var idle = true

func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * currentSpeed
	if input_dir != Vector2.ZERO:
		idle = false
	else:
		idle = true

	if input_dir.y < 0:
		direction = Movements.UP
	elif input_dir.y > 0:
		direction = Movements.DOWN

	# debug speed mode
	if Input.is_action_just_pressed("run"):
		currentSpeed = runSpeed

	if Input.is_action_just_released("run"):
		currentSpeed = baseSpeed

func _physics_process(delta):
	if !PlayerManager.canPlay:
		return

	get_input()
	move_and_collide(velocity * delta)
	position.x = round(position.x)
	position.y = round(position.y)

func reset():
	currentSpeed = baseSpeed

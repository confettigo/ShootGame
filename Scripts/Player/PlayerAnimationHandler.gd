extends AnimatedSprite2D
@export var movement : Movement 

func _process(_delta: float) -> void:
	if movement.idle == true:
		match movement.direction:
			movement.Movements.UP:
				play("standingUp")
			movement.Movements.DOWN:
				play("standingDown")
		return
	
	if movement.direction == movement.Movements.UP && animation != "walkingUp":
		play("walkingUp")
	elif movement.direction == movement.Movements.DOWN && animation != "walkingDown":
		play("walkingDown")

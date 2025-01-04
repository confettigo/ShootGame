extends Sprite2D

func _process(_delta: float) -> void:
	position.y = round(sin(Time.get_ticks_msec() * 0.005) * 2) - 5
	

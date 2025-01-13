extends Node2D

@export var offsetHover : float
@export var signE : float = 1

func _process(_delta: float) -> void:
	position.y = round(sin(Time.get_ticks_msec() * signE * 0.005) * 2) - offsetHover
	

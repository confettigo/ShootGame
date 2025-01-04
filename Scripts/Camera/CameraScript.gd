extends Camera2D

@export var player : CharacterBody2D
var gameSize = Vector2i(240,180)
@onready var windowScale : float = (get_window().size/gameSize).x
@onready var actualCamPos = global_position
func _ready() -> void:
	print((get_window().size/gameSize).x)
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

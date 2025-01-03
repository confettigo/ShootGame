extends Node
var aimDir = Vector2(0,-1)
@export var sprite:Sprite2D
@export var parent:CharacterBody2D

func _ready() -> void:
	pass

func getInput():
	var inputDir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if(inputDir == Vector2(0,0)):
		return
	aimDir = inputDir


func _process(delta: float) -> void:
	getInput()
	sprite.position = aimDir*50

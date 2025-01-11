@tool
extends Node

class_name Cover

@export var health : Health
@export var coverSprite : Sprite2D
var index = 0
signal breakage(index)

func _ready():
	if !Engine.is_editor_hint():
		health.onDeath.connect(onDeath)

func onDeath():
	breakage.emit(index)
	queue_free()

func changeSprite(sprite):
	coverSprite.texture = sprite

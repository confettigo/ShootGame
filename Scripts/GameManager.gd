extends Node

class_name GameManager

@export var subViewportContainer : SubViewportContainer
@export var subViewport : SubViewport
@export var gameScene : Node

func _ready() -> void:
	CameraController.viewportContainer = subViewportContainer
	CameraController.viewport = subViewport
	



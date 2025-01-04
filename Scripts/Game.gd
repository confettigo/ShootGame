extends Node2D

@export var subViewportContainer : SubViewportContainer
@export var subViewport : SubViewport

func _ready() -> void:
	CameraController.viewportContainer = subViewportContainer
	CameraController.viewport = subViewport

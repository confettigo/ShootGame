extends Node2D
@onready var subViewportContainer: SubViewportContainer = $SubViewportContainer
@onready var subViewport: SubViewport = $SubViewportContainer/SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CameraController.viewportContainer = subViewportContainer
	CameraController.viewport = subViewport

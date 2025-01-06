extends Node

@export var subViewportContainer : SubViewportContainer
@export var subViewport : SubViewport
@export var gameScene : Node
@export var debugInterface : CanvasLayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	CameraController.viewportContainer = subViewportContainer
	CameraController.viewport = subViewport
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		toggleMouseDisplay()
		get_tree().paused = !get_tree().paused
		debugInterface.visible = !debugInterface.visible
			
func toggleMouseDisplay():
	if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


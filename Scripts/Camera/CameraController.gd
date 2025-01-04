extends Node

var viewportContainer = null
var viewport = null
var camera : CameraScript

func _ready():
	camera = get_tree().get_root().find_child("Camera2D", true, false)
	
func resetCamera():
	camera.resetCamera()

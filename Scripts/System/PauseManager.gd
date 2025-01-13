extends Node

var debugInterface : CanvasLayer
var isDebugPaused = false
var isPaused = false

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	debugInterface = get_tree().get_root().find_child("DebugInterface", true, false)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		debugPause()
			
func toggleMouseDisplay():
	if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func debugPause():
	if isPaused:
		return
	
	toggleMouseDisplay()
	debugInterface.visible = !debugInterface.visible
	get_tree().paused = !get_tree().paused
	isDebugPaused = get_tree().paused

func isGamePaused() -> bool:
	return isDebugPaused

func wheelPause():
	get_tree().paused = !get_tree().paused
	isPaused = !isPaused
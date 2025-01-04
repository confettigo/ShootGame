extends Camera2D

class_name CameraScript

@export var player : CharacterBody2D

@onready var gameSize := Vector2i(80, 45)
@onready var windowScale := (DisplayServer.window_get_size()/gameSize).x

@onready var actualCamPos = global_position

@onready var size = DisplayServer.window_get_size()

@onready var actual_cam_pos := global_position

@onready var highestVerticalPos : float = player.global_position.y

@export var smoothness : float = 5 

var playerPos : Vector2

func _process(delta):
	if highestVerticalPos > player.global_position.y:
		highestVerticalPos = player.global_position.y
	playerPos = Vector2(121, highestVerticalPos)
	actual_cam_pos = lerp(actual_cam_pos, playerPos, smoothness * delta)
	var cam_subpixel_pos = actual_cam_pos.round() - actual_cam_pos
	CameraController.viewportContainer.material.set_shader_parameter("camOffset", cam_subpixel_pos )
	global_position = actual_cam_pos.round()

func resetCamera():
	global_position = Vector2(121, player.position.y)
	playerPos = global_position
	highestVerticalPos = player.position.y
	actual_cam_pos = global_position

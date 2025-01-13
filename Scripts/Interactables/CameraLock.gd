extends Node

@export var trigger : Trigger

func _ready():
	trigger.data = true
	trigger.onPlayerTriggerEnter.connect(CameraController.lockCamera)
extends Node

class_name DamagedEffect

@export var effectDuration : float = 1
var currentTime : float = 0
var isDamaged = true

func _process(delta):
	if isDamaged:
		if currentTime > 0:
			currentTime -= delta
			self.modulate.a = 0.3 if Engine.get_frames_drawn() % 10 == 0 else 1.0
		else:
			self.modulate.a = 1.0
			isDamaged = false

func onHit():
	isDamaged = true
	currentTime = effectDuration
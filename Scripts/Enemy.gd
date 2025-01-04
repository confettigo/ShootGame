extends Node

@export var health : Health
@export var baseDamageTime : float = 1

var timer : float = 0
var isDamaged = true

func _ready():
	health.onHit.connect(onHit)
	health.onDeath.connect(onDeath)

func onHit():
	isDamaged = true
	timer = baseDamageTime

func onDeath():
	queue_free()

func _process(delta):
	if isDamaged:
		if timer > 0:
			timer -= delta
			# change this to an animation
			self.modulate.a = 0.3 if Engine.get_frames_drawn() % 10 == 0 else 1.0
		else:
			self.modulate.a = 1.0
			isDamaged = false
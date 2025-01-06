extends Node2D

@onready var playerHealth = self.get_parent().get_node("Health")
@export var baseDamageTime : float = 1
@export var sprite : AnimatedSprite2D
var damagedTimer : float = 0
var isDamaged = true

func _ready():
	playerHealth.onHit.connect(onPlayerHit)

func onPlayerHit():
	isDamaged = true
	damagedTimer = baseDamageTime

func _process(delta: float) -> void:
	if isDamaged:
		if damagedTimer > 0:
			damagedTimer -= delta
			# change this to an animation
			sprite.modulate.a = 0.3 if Engine.get_frames_drawn() % 10 == 0 else 1.0
		else:
			sprite.modulate.a = 1.0
			isDamaged = false

extends Sprite2D


@onready var playerHealth = self.get_parent().get_node("Health")
@export var baseDamageTime : float = 1
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
			self.modulate.a = 0.3 if Engine.get_frames_drawn() % 10 == 0 else 1.0
		else:
			self.modulate.a = 1.0
			isDamaged = false


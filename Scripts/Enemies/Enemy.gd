extends Node

@export var health : Health
@export var baseDamageTime : float = 1
@export var baseShootingCooldown : float = 2
@export var shootingRange : float = 5
@export var projectileTemplate : PackedScene
@onready var projectileContainer : Node2D = WorldManager.projectileContainer
@onready var playerTarget : CharacterBody2D = PlayerManager.player

var damagedTimer : float = 0
var isDamaged = true

var shootingTimer

func _ready():
	health.onHit.connect(onHit)
	health.onDeath.connect(onDeath)
	shootingTimer = randf_range(baseShootingCooldown - 2, baseShootingCooldown + 2)

func onHit():
	isDamaged = true
	damagedTimer = baseDamageTime

func onDeath():
	queue_free()

func _process(delta):
	if isDamaged:
		if damagedTimer > 0:
			damagedTimer -= delta
			# change this to an animation
			self.modulate.a = 0.3 if Engine.get_frames_drawn() % 10 == 0 else 1.0
		else:
			self.modulate.a = 1.0
			isDamaged = false

	

	# shoot
	shootingTimer -= delta

	# range check
	if self.position.distance_to(playerTarget.position) > shootingRange:
		return

	if shootingTimer <= 0:
		shootingTimer = baseShootingCooldown
		var projectile : EnemyProjectile = projectileTemplate.instantiate()
		projectileContainer.add_child(projectile)
		projectile.position = self.position
		projectile.setup((playerTarget.position - self.position).normalized())
		

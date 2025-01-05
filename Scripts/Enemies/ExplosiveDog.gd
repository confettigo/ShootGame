extends Node

@export var health : Health

@export var speed : float = 100
@export var attackRange : float = 8
@export var explosionParticles : PackedScene
var chaseEnabled

@onready var playerTarget : CharacterBody2D = PlayerManager.player

func _ready():
	health.onDeath.connect(onDeath)

func onDeath():
	ParticleSystemManager.playParticleSystem(explosionParticles, self.position)
	queue_free()

func _process(delta):
	if chaseEnabled:
		self.position = self.position.move_toward(playerTarget.position, delta * speed)

	if !chaseEnabled && self.position.distance_to(playerTarget.position) <= attackRange:
		chaseEnabled = true

func _on_trigger_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		var bodyHealth : Health = body.get_node("Health")
		bodyHealth.hit(10)
		onDeath()
	

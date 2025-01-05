extends Node

var particleSystemContainer : Node2D

func _ready():
	particleSystemContainer = get_tree().get_root().find_child("ParticleSystemContainer", true, false)

func playParticleSystem(particleScene : PackedScene, _position : Vector2):
	var particleSystem : CPUParticles2D = particleScene.instantiate()
	particleSystemContainer.add_child(particleSystem)
	particleSystem.position = _position
	particleSystem.emitting = true

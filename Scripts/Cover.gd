extends Node

@export var health : Health

func _ready():
	health.onDeath.connect(onDeath)

func onDeath():
	queue_free()
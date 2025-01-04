extends Node

class_name Health

@export var maxHealth : int = 5;
var currentHealth : int;

signal onHit
signal onDeath

func _ready() -> void:
	currentHealth = maxHealth;

func hit(damage : int):
	currentHealth -= damage
	
	if currentHealth > 0:
		onHit.emit()
	else:
		onDeath.emit()

	
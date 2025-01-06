extends Node

class_name Health

@export var maxHealth : int = 5;
var currentHealth : int;
var invulnerable : bool = false

signal onHit
signal onDeath

func _ready() -> void:
	reset()

func hit(damage : int):
	if invulnerable:
		return

	if currentHealth <= 0:
		return
		
	currentHealth -= damage
	
	if currentHealth > 0:
		onHit.emit()
	else:
		onDeath.emit()

func setInvulnerability(state : bool):
	invulnerable = state

func reset():
	currentHealth = maxHealth;
	
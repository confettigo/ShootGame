extends Node

@export var weapon : Weapon
@export var sprite : Sprite2D

func _ready():
	sprite.texture = weapon.pickupSprite

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		PlayerManager.playerAiming.changeWeapon(weapon)
		queue_free()

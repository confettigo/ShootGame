extends Node

@export var weapon : Weapon
@export var sprite : Sprite2D
@export var shadow : Sprite2D

func _ready():
	sprite.texture = weapon.pickupSprite
	shadow.texture = weapon.pickupSprite

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		WeaponManager.changeWeapon(weapon)
		queue_free()

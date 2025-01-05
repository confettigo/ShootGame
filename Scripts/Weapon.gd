extends Resource
class_name Weapon

enum type {SINGLE, SPRAY}

@export var pickupSprite : Texture
@export var damage : int
@export var shootingCooldown : float
@export var shootingType : type
extends Resource
class_name Weapon

enum WEAPON_TYPE {SINGLE, SPRAY}

@export var name : String
@export var pickupSprite : Texture
@export var damage : int
@export var startingAmmo : int
@export var shootingCooldown : float
@export var shootingType : WEAPON_TYPE

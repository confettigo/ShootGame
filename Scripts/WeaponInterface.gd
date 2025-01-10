extends Node

@export var weaponSprite : TextureRect
@export var weaponShadowSprite : TextureRect
@export var ammoSprite : TextureRect
@export var ammoShadowSprite : TextureRect
@export var ammoLabel : Label

func _init():
	WeaponManager.onCurrentWeaponChanged.connect(updateWeaponInterface)
	WeaponManager.onCurrentWeaponUsed.connect(updateAmmoCountLabel)

func updateWeaponInterface(currentWeapon : WeaponManager.PlayableWeapon):
	weaponSprite.texture = currentWeapon.weaponData.pickupSprite
	ammoSprite.texture = currentWeapon.weaponData.ammoSprite
	if currentWeapon.ammo == -1:
		ammoLabel.text = "∞"
	else:
		ammoLabel.text = str(currentWeapon.ammo)

func updateAmmoCountLabel(currentAmmo : int):
	if currentAmmo < 0:
		return
	ammoLabel.text = str(currentAmmo)
	

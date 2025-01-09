extends Node

class PlayableWeapon:
	var weaponData : Weapon
	var owned : bool = false
	var ammo : int = 0

	func _init(_weaponData : Weapon, _owned : bool, _ammo : int) -> void:
		weaponData = _weaponData
		owned = _owned
		ammo = _ammo

	func print():
		print(weaponData.resource_name + " - Owned: " + str(owned) + " - Ammo: " + str(ammo))

var weaponList : Array[Weapon]
@onready var aiming = PlayerManager.playerAiming
var playerWeaponList : Array[PlayableWeapon]
var currentWeapon : PlayableWeapon

signal onCurrentWeaponChanged(currentWeapon : PlayableWeapon)
signal onCurrentWeaponUsed(currentAmmo : int)

func _ready():
	loadWeapons()
	changeWeaponIndex(0)
	
func loadWeapons():
	var path = "res://Data/Weapons/"
	var weaponFolder = DirAccess.open(path)
	var filePaths = weaponFolder.get_files()
	if !filePaths:
		printerr("No weapon files found!")

	for fileName in filePaths:
		weaponList.append(load(path + fileName))

	# Should load from save (if you owned the weapon)
	for i in weaponList.size():
		playerWeaponList.append(PlayableWeapon.new(weaponList[i], false, weaponList[i].startingAmmo))


func changeWeaponIndex(index : int):
	currentWeapon = playerWeaponList[index]

	if !currentWeapon.owned:
		# New weapon!
		currentWeapon.owned = true
		print("New weapon!")
	else:
		# Already owned weapon
		if currentWeapon.ammo == -1:
			# Do not reload infinite weapons
			pass
		else:
			# Should be a set value per weapon 
			currentWeapon.ammo += 30
	
	currentWeapon.print()
	aiming.reset()

	onCurrentWeaponChanged.emit(currentWeapon)

func changeWeapon(_weapon : Weapon):
	var i : int = 0
	for weapon in playerWeaponList:
		if _weapon == weapon.weaponData:
			changeWeaponIndex(i)
		i = i + 1

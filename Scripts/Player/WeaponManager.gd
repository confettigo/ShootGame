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
var currentWeaponIndex : int
var previousWeaponIndex : int

signal onCurrentWeaponChanged(currentWeapon : PlayableWeapon)
signal onCurrentWeaponUsed(currentAmmo : int)
signal onNewWeaponOwned(newWeaponIndex : int)

func _ready():
	loadWeapons()
	getWeaponIndex(0)
	previousWeaponIndex = 0
	
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

func getWeaponIndex(index : int):
	previousWeaponIndex = currentWeaponIndex
	currentWeapon = playerWeaponList[index]
	currentWeaponIndex = index
	if !currentWeapon.owned:
		# New weapon!
		currentWeapon.owned = true
		print("New weapon!")
		onNewWeaponOwned.emit(index)
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

func changeWeaponIndex(index : int):
	previousWeaponIndex = currentWeaponIndex
	currentWeapon = playerWeaponList[index]
	currentWeaponIndex = index
	
	currentWeapon.print()
	aiming.reset()

	onCurrentWeaponChanged.emit(currentWeapon)

func getWeapon(_weapon : Weapon):
	var i : int = 0
	for weapon in playerWeaponList:
		if _weapon == weapon.weaponData:
			getWeaponIndex(i)
		i = i + 1

func isWeaponOwned(index : int) -> bool:
	return index < playerWeaponList.size() && playerWeaponList[index].owned

func weaponHasAmmo(index : int) -> bool:
	return index < playerWeaponList.size() && playerWeaponList[index].ammo != 0

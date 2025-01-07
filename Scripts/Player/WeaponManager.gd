extends Node

class PlayableWeapon:
	var weaponData : Weapon
	var owned : bool = false
	var ammo : int = 0

	func _init(_weaponData : Weapon, _owned : bool, _ammo : int) -> void:
		weaponData = _weaponData
		owned = _owned
		ammo = _ammo

var weaponList : Array[Weapon]
@onready var aiming = PlayerManager.playerAiming
var playerWeaponList : Array[PlayableWeapon]
var currentWeapon : PlayableWeapon

func _ready():
	loadWeapons()
	currentWeapon = playerWeaponList[0]
	
func loadWeapons():
	var path = "res://Data/Weapons/"
	var weaponFolder = DirAccess.open(path)
	var filePaths = weaponFolder.get_files()
	if !filePaths:
		printerr("No weapon files found!")

	for fileName in filePaths:
		weaponList.append(load(path + fileName))

	# Load from save (currently hardcoded owned and ammo)
	playerWeaponList.append(PlayableWeapon.new(weaponList[0], true, -1))
	playerWeaponList.append(PlayableWeapon.new(weaponList[1], false, 0))
	playerWeaponList.append(PlayableWeapon.new(weaponList[2], false, 0))

	
func changeWeapon(index : int):
	currentWeapon = playerWeaponList[index]
	print(currentWeapon.weaponData.resource_name)
	aiming.reset()
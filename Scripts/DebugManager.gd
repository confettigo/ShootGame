extends Node

@export var shootingModeDropdown : OptionButton
@export var godMode : CheckBox
@export var weaponSelectDropdown : OptionButton
@export var weapons : Array[Weapon]

func _ready():
	self.visibility_changed.connect(refresh)

	for shootingMode in PlayerManager.playerAiming.SHOOTING_CONTROL_MODE:
		shootingModeDropdown.add_item(shootingMode)
	shootingModeDropdown.select(PlayerManager.playerAiming.shootingMode)
	shootingModeDropdown.item_selected.connect(PlayerManager.playerAiming.changePlayerAimingMode)

	godMode.toggled.connect(PlayerManager.playerHealth.setInvulnerability)

	for weapon in weapons:
		weaponSelectDropdown.add_item(weapon.name)
	weaponSelectDropdown.select(weapons.find(PlayerManager.playerAiming.currentWeapon))
	weaponSelectDropdown.item_selected.connect(changeWeaponDebug)

func refresh():
	weaponSelectDropdown.select(weapons.find(PlayerManager.playerAiming.currentWeapon))

func changeWeaponDebug(index : int):
	PlayerManager.playerAiming.changeWeapon(weapons[index])
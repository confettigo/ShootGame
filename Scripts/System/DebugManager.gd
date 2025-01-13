extends Node

@export var shootingModeDropdown : OptionButton

@export var godMode : CheckButton

@export var weaponSelectDropdown : OptionButton
@onready var weapons = WeaponManager.weaponList

@export var checkpointSelectDropdown : OptionButton

func _ready():
	self.visibility_changed.connect(refresh)

	for shootingMode in PlayerManager.playerAiming.SHOOTING_CONTROL_MODE:
		shootingModeDropdown.add_item(shootingMode)
	shootingModeDropdown.select(PlayerManager.playerAiming.shootingMode)
	shootingModeDropdown.item_selected.connect(PlayerManager.playerAiming.changePlayerAimingMode)

	godMode.toggled.connect(PlayerManager.playerHealth.setInvulnerability)
	
	for weapon in weapons:
		weaponSelectDropdown.add_item(weapon.resource_name)
	weaponSelectDropdown.select(weapons.find(WeaponManager.currentWeapon.weaponData))
	weaponSelectDropdown.item_selected.connect(WeaponManager.getWeaponIndex)

	for checkpoint in WorldManager.levelCheckpoints:
		checkpointSelectDropdown.add_item(checkpoint.name)
	checkpointSelectDropdown.select(WorldManager.currentCheckpointIndex)
	checkpointSelectDropdown.item_selected.connect(WorldManager.setCheckpointIndex)

func refresh():
	weaponSelectDropdown.select(weapons.find(WeaponManager.currentWeapon.weaponData))
	checkpointSelectDropdown.select(WorldManager.currentCheckpointIndex)

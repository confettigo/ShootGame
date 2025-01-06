extends Node

@export var shootingModeDropdown : OptionButton
@export var godMode : CheckBox

func _ready():
	for shootingMode in PlayerManager.playerAiming.shootingControlMode:
		shootingModeDropdown.add_item(shootingMode)
	shootingModeDropdown.select(PlayerManager.playerAiming.shootingMode)
	shootingModeDropdown.item_selected.connect(PlayerManager.playerAiming.changePlayerAimingMode)

	godMode.toggled.connect(PlayerManager.playerHealth.setInvulnerability)

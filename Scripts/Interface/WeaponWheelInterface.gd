extends Node

@export var background : Node
@export var weaponWheelContainer : Node

@export var currentWeaponColor : Color = Color.DEEP_SKY_BLUE
@export var hoverWeaponColor : Color = Color.BLUE_VIOLET

var weaponWheelSpriteList : Array[TextureRect]
var weaponWheelOriginalPosition : Array[Vector2]

var isWheelOpen : bool = false
var currentWheelPartIndex
var previousIndex = -1
var selectDir : Vector2

func _ready():
	WeaponManager.onCurrentWeaponChanged.connect(refreshWheelPart)
	WeaponManager.onNewWeaponOwned.connect(unlockWheelPart)

	background.visible = false
	weaponWheelContainer.visible = false

	weaponWheelSpriteList.assign(weaponWheelContainer.get_children())

	currentWheelPartIndex = WeaponManager.currentWeaponIndex
	weaponWheelSpriteList[currentWheelPartIndex].self_modulate = currentWeaponColor

	for i in weaponWheelSpriteList.size():
		var weaponWheelPart = weaponWheelSpriteList[i]
		weaponWheelOriginalPosition.append(weaponWheelPart.position)
		if weaponWheelPart.get_child_count() > 0:
			weaponWheelPart.get_child(0).texture = WeaponManager.playerWeaponList[i].weaponData.pickupSprite
			if !WeaponManager.playerWeaponList[i].owned:
				# Paint the sprite black if you don't own the weapon
				weaponWheelPart.get_child(0).modulate = Color.BLACK
		else:
			# If there's no weapon paint the wheel part gray
			weaponWheelPart.modulate = Color.DIM_GRAY


func getKeyboardInput():
	var inputDir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	selectDir = inputDir.normalized()

func _process(_delta: float) -> void:
	if PauseManager.isGamePaused():
		return

	if Input.is_action_just_pressed("toggleWheel"):
		setWheelState(true)

	if !isWheelOpen:
		return
		
	getKeyboardInput()
	
	if selectDir.length() == 0:
		resetPreviousWeaponWheelTile()
		previousIndex = -1
	else: 
		selectWheelPart()

	if Input.is_action_just_released("toggleWheel"):
		setWheelState(false)
		if previousIndex >= 0 && previousIndex != currentWheelPartIndex && WeaponManager.isWeaponOwned(previousIndex) && WeaponManager.weaponHasAmmo(previousIndex):
			WeaponManager.changeWeaponIndex(previousIndex)
			weaponWheelSpriteList[currentWheelPartIndex].self_modulate = Color.WHITE
			currentWheelPartIndex = previousIndex
			weaponWheelSpriteList[currentWheelPartIndex].self_modulate = currentWeaponColor
			weaponWheelSpriteList[currentWheelPartIndex].position = weaponWheelOriginalPosition[currentWheelPartIndex]
			previousIndex = -1

func resetPreviousWeaponWheelTile():
	var previousWheelSprite = weaponWheelSpriteList[previousIndex]
	previousWheelSprite.self_modulate =  Color.WHITE
	previousWheelSprite.position = weaponWheelOriginalPosition[previousIndex]
	previousWheelSprite.z_index = 0

func unlockWheelPart(index : int):
	weaponWheelSpriteList[index].get_child(0).modulate = Color.WHITE

func refreshWheelPart(_currentWeapon : WeaponManager.PlayableWeapon):
	currentWheelPartIndex = WeaponManager.currentWeaponIndex
	weaponWheelSpriteList[WeaponManager.previousWeaponIndex].self_modulate = Color.WHITE
	weaponWheelSpriteList[currentWheelPartIndex].self_modulate = Color.DEEP_SKY_BLUE

func setWheelState(state : bool):
	isWheelOpen = state
	background.visible = state
	weaponWheelContainer.visible = state
	PauseManager.wheelPause()

func selectWheelPart():
	var angle = selectDir.angle() / (PI/4)
	var indexFromAngle = wrapi(int(angle) + 2, 0, 8) 

	if indexFromAngle == currentWheelPartIndex:
		return

	if previousIndex >= 0:
		resetPreviousWeaponWheelTile()

	hoverWheelPart(indexFromAngle)

func hoverWheelPart(index : int):
	var currentWheelSprite = weaponWheelSpriteList[index]
	if index < WeaponManager.weaponList.size() - 1:
		if WeaponManager.weaponHasAmmo(index):
			currentWheelSprite.self_modulate = hoverWeaponColor
		else:
			currentWheelSprite.self_modulate = Color.DARK_RED
	else:
		currentWheelSprite.self_modulate = Color.DIM_GRAY
	currentWheelSprite.position = weaponWheelOriginalPosition[index] + selectDir * 50
	previousIndex = index

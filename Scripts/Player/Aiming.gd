extends Node

class_name Aiming

@export var sprite : Sprite2D
@export var parent : CharacterBody2D
@export var projectileTemplate : PackedScene
@export var currentWeapon : Weapon

@onready var projectileContainer : Node2D = WorldManager.projectileContainer
@onready var timer = currentWeapon.shootingCooldown 
var isShooting : bool
var canShoot : bool
var aimDir = Vector2(0,-1)



func getInput():
	var inputDir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if(inputDir == Vector2(0,0)):
		return
	aimDir = inputDir

func _process(delta: float) -> void:
	if !PlayerManager.canPlay:
		return

	getInput()
	sprite.position = aimDir * 50
	sprite.position = round(sprite.position)

	if Input.is_action_just_pressed("shoot"):
		isShooting = true

	if Input.is_action_just_released("shoot"):
		isShooting = false

	if !canShoot:
		timer -= delta
		if timer <= 0:
			canShoot = true

	if isShooting && canShoot:
		shoot()

func shoot():
	canShoot = false
	timer = currentWeapon.shootingCooldown
	match currentWeapon.shootingType:
		Weapon.type.SINGLE:
			shootSingle()
		Weapon.type.SPRAY:
			shootSpray()
		

func shootSingle():
	var projectile : Projectile = projectileTemplate.instantiate()
	projectileContainer.add_child(projectile)
	projectile.position = parent.position
	projectile.setup(aimDir.normalized())

func shootSpray():
	for i in 5:
		var projectile : Projectile = projectileTemplate.instantiate()
		projectileContainer.add_child(projectile)
		projectile.position = parent.position
		projectile.setup(aimDir.rotated(deg_to_rad(randf_range(-30, 30))), 1, randf_range(50, 100))
	
func changeWeapon(newWeapon : Weapon):
	currentWeapon = newWeapon
	timer = 0
	canShoot = true

func reset():
	isShooting = false
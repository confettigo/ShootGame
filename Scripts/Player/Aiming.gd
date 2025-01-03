extends Node

@export var sprite : Sprite2D
@export var parent : CharacterBody2D
@export var projectileTemplate : PackedScene
@export var projectileContainer : Node2D

var isShooting : bool
var aimDir = Vector2(0,-1)

func getInput():
	var inputDir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if(inputDir == Vector2(0,0)):
		return
	aimDir = inputDir


func _process(_delta: float) -> void:
	getInput()
	sprite.position = aimDir * 50

	if Input.is_action_just_pressed("shoot"):
		isShooting = true

	if Input.is_action_just_released("shoot"):
		isShooting = false

	if isShooting:
		var projectile : Projectile = projectileTemplate.instantiate()
		projectileContainer.add_child(projectile)
		projectile.position = parent.position
		projectile.setup(aimDir.normalized())

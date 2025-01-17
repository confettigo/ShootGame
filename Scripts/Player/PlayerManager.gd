extends Node

var player : CharacterBody2D
var checkpoint : Node2D
var boss : CharacterBody2D
var playerMoving : Movement
var playerHealth : Health
var playerAiming : Aiming
var canPlay: bool = true

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	checkpoint = get_tree().get_root().find_child("Checkpoint", true, false)
	boss = get_tree().get_root().find_child("Boss", true, false)

	playerMoving = player as Movement
	playerHealth = player.get_node("Health")
	playerAiming = player.get_node("Aiming")
	playerHealth.onDeath.connect(onPlayerDeath)	

func onPlayerDeath():
	player.visible = false
	Scheduler.schedule(boss.reset, 1)
	Scheduler.schedule(resetPlayer, 1)
	setPlaying(false)
	player.position = Vector2.INF

func resetPlayer():
	setPlaying(true)
	player.visible = true
	player.position = WorldManager.getCurrentCheckpointPosition()
	playerMoving.reset()
	playerHealth.reset()
	playerAiming.reset()
	CameraController.resetCamera()

func setPlaying(_canPlay : bool):
	canPlay = _canPlay
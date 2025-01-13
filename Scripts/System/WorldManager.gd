extends Node

var projectileContainer : Node2D
var currentCheckpointIndex : int = 0
var levelCheckpoints : Array[Node]

func _ready():
	projectileContainer = get_tree().get_root().find_child("ProjectileContainer", true, false)
	var checkpointContainer = get_tree().get_root().find_child("CheckpointContainer", true, false)
	levelCheckpoints = checkpointContainer.get_children()

func checkpointReached(index : int):
	currentCheckpointIndex = index

func getCurrentCheckpointPosition() -> Vector2:
	return levelCheckpoints[currentCheckpointIndex].position

func setCheckpointIndex(index : int):
	checkpointReached(index)
	PlayerManager.resetPlayer()

extends Node

@export var trigger : Trigger
@export var checkpointIndex : int

func _ready():
	trigger.data = checkpointIndex
	trigger.onPlayerTriggerEnter.connect(WorldManager.checkpointReached)
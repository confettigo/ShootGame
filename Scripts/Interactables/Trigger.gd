extends Node

class_name Trigger

@export var singleUse : bool = false
var oneShot : bool = false

signal onPlayerTriggerEnter
var data : Variant

func _on_body_entered(body:Node2D) -> void:
	if singleUse && oneShot:
		return

	if body.is_in_group("player"):
		oneShot = true
		onPlayerTriggerEnter.emit(data)
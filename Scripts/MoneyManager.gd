extends Node

signal onMoneyUpdate
var money = 0



func _ready() -> void:
	moneyUpdate(0)
	pass

func moneyUpdate(value):
	money += value
	onMoneyUpdate.emit()

func _process(delta: float) -> void:
	pass

extends Node
@export var value : int = 100
func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		MoneyManager.moneyUpdate(value)
		queue_free()

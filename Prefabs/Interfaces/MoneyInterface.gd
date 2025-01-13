extends HBoxContainer
@export var moneyText : Label
func _init() -> void:
	MoneyManager.onMoneyUpdate.connect(onMoneyUpdate)

func _ready() -> void:
	pass

func onMoneyUpdate():
	moneyText.text = str(MoneyManager.money)

func _process(delta: float) -> void:
	pass

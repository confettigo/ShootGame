extends Node

class_name DamageArea

@export var damage : int
var activateTimer : Timer
var queueFreeTimer : Timer

func setup(activateOnTime: float = 0, deleteOnTime : float = -1):
	if activateOnTime > 0:
		self.monitoring = false
		self.visible = false
		activateTimer = Timer.new()
		activateTimer.set_one_shot(true)
		add_child(activateTimer)
		activateTimer.start(activateOnTime)
		activateTimer.timeout.connect(activate)

	if deleteOnTime > 0:
		queueFreeTimer = Timer.new()
		queueFreeTimer.set_one_shot(true)
		add_child(queueFreeTimer)
		queueFreeTimer.start(activateOnTime + deleteOnTime)
		queueFreeTimer.timeout.connect(remove_area)

func _on_projectile_body_entered(body:Node2D) -> void:
	if body.is_in_group("bounds"):
		queue_free()
	if body.is_in_group("damageable"):
		# queue_free()
		var bodyHealth : Health = body.get_node("Health")
		bodyHealth.hit(damage)

func activate():
	self.visible = true
	self.monitoring = true

func remove_area():
	queue_free()

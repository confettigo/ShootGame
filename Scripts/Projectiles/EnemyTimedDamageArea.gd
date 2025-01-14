extends Node

class_name EnemyTimedDamageArea

@export var damage : int
@export var timedArea : Node2D

var started = false
var currentTimer = 0.0
var cooldown = 2

func setup(displayOnTime : float, activateCountdownTime : float):
	self.visible = false
	self.monitoring = false
	cooldown = activateCountdownTime
	var activateTimer = Timer.new()
	activateTimer.set_one_shot(true)
	add_child(activateTimer)
	activateTimer.start(displayOnTime)
	activateTimer.timeout.connect(activateCountdown)

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("bounds"):
		queue_free()
	if body.is_in_group("player"):
		queue_free()
		var bodyHealth : Health = body.get_node("Health")
		bodyHealth.hit(damage)

func _process(delta):
	if !started || self.monitoring:
		return

	if currentTimer > cooldown:
		self.monitoring = true
		return

	currentTimer += delta
	timedArea.scale = lerp(Vector2.ZERO, Vector2.ONE, currentTimer / cooldown)

func activateCountdown():
	self.visible = true
	var activateCountdownTimer = Timer.new()
	activateCountdownTimer.set_wait_time(cooldown) 
	activateCountdownTimer.set_one_shot(true)
	add_child(activateCountdownTimer)
	activateCountdownTimer.start()
	activateCountdownTimer.timeout.connect(removeDamageArea)
	started = true

func removeDamageArea():
	var clearDamageAreaTimer = Timer.new()
	clearDamageAreaTimer.set_wait_time(0.5) 
	clearDamageAreaTimer.set_one_shot(true)
	add_child(clearDamageAreaTimer)
	clearDamageAreaTimer.start()
	clearDamageAreaTimer.timeout.connect(queue_free)
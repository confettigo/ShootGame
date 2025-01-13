extends Node

class_name EnemyTimedDamageArea

@export var damage : int
@export var timedArea : Node2D
@export var collider : CollisionShape2D

var currentTimer = 0.0
var cooldown = 2

func setup():
	var bullet_free_timer = Timer.new()
	bullet_free_timer.set_wait_time(2.2) 
	bullet_free_timer.set_one_shot(true)
	add_child(bullet_free_timer)
	bullet_free_timer.start()
	bullet_free_timer.timeout.connect(queue_free)

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("bounds"):
		queue_free()
	if body.is_in_group("player"):
		queue_free()
		var bodyHealth : Health = body.get_node("Health")
		bodyHealth.hit(damage)

func _process(delta):
	if !collider.disabled:
		return

	if currentTimer > cooldown:
		collider.disabled = false
		return

	currentTimer += delta

	timedArea.scale = lerp(Vector2.ZERO, Vector2.ONE, currentTimer / cooldown)

func remove():
	queue_free()
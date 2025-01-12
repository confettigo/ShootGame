extends Area2D

class_name EnemyProjectile

@export var speed = 150
@export var damage : int
var direction : Vector2

func setup(_direction : Vector2, deleteOnTime : float = 10):
	direction = _direction

	var bullet_free_timer = Timer.new()
	bullet_free_timer.set_wait_time(deleteOnTime) 
	bullet_free_timer.set_one_shot(true)
	add_child(bullet_free_timer)
	bullet_free_timer.start()
	bullet_free_timer.timeout.connect(queue_free)

func _physics_process(delta):
	position += direction * speed * delta

func _on_projectile_body_entered(body:Node2D) -> void:
	if body.is_in_group("bounds"):
		queue_free()
	if body.is_in_group("player"):
		queue_free()
		var bodyHealth : Health = body.get_node("Health")
		bodyHealth.hit(damage)
		

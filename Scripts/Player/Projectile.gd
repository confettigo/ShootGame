extends Area2D

class_name Projectile

@export var speed = 150
@export var damage : int
var direction : Vector2

func setup(_direction : Vector2):
	direction = _direction

func _physics_process(delta):
	position += direction * speed * delta

func _on_projectile_body_entered(body:Node2D) -> void:
	if body.is_in_group("bounds"):
		queue_free()
	if body.is_in_group("damageable"):
		queue_free()
		var bodyHealth : Health = body.get_node("Health")
		bodyHealth.hit(damage)
		

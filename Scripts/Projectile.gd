class_name Projectile

extends Area2D

@export var speed = 150
@export var damage : int
var direction : Vector2

func setup(_direction : Vector2):
	# damage = _damage
	# speed = _speed
	direction = _direction

func _physics_process(delta):
	position += direction * speed * delta

func _on_projectile_body_entered(body):
	if body.is_in_group("enemy"):
		pass
		# damage enemy
	queue_free()

extends Area2D

class_name Projectile

@export var speed : float = 150 
@export var damage : int
var direction : Vector2
var bullet_free_timer : Timer

func setup(_direction : Vector2, deleteOnTime : float = -1, _speed : float = 150):
	direction = _direction
	speed = _speed
	if deleteOnTime > 0:
		bullet_free_timer = Timer.new()
		bullet_free_timer.set_wait_time(deleteOnTime) 
		bullet_free_timer.set_one_shot(true)
		add_child(bullet_free_timer)
		bullet_free_timer.start()
		bullet_free_timer.connect("timeout", remove_bullet)

func _physics_process(delta):
	position += direction * speed * delta
	# Removed rounding due to flamethrower!
	# position = position.round()

func _on_projectile_body_entered(body:Node2D) -> void:
	if body.is_in_group("bounds"):
		queue_free()
	if body.is_in_group("damageable"):
		print("Hit " + body.name)
		queue_free()
		var bodyHealth : Health = body.get_node("Health")
		bodyHealth.hit(damage)
		
func remove_bullet():
	queue_free()

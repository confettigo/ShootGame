extends Node

func schedule(function_name, delay : float):
	print("asd")
	var timer = Timer.new()
	timer.timeout.connect(function_name)
	timer.timeout.connect(Callable(timer, "queue_free"))
	timer.wait_time = delay
	get_tree().root.add_child(timer)
	timer.start()

func _on_timer_timeout():
	print("as")
	queue_free()
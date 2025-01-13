extends Node

func schedule(function_name, delay : float):
	var timer = Timer.new()
	timer.timeout.connect(function_name)
	timer.timeout.connect(Callable(timer, "queue_free"))
	timer.wait_time = delay
	get_tree().root.add_child(timer)
	timer.start()

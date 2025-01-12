class_name Cooldown

var baseTime : float
var currentTime : float
var one_shot : bool = false
var stopped : bool = false
signal timeout 

func _init(_baseTime : float, timeoutCall, _one_shot = false) -> void:
	baseTime = _baseTime
	currentTime = baseTime
	one_shot = _one_shot
	timeout.connect(timeoutCall)

func tick(delta : float):
	if stopped: 
		return;

	currentTime -= delta
	if currentTime <= 0:
		timeout.emit()
		if one_shot:
			stopped = true
		currentTime = baseTime

func reset():
	currentTime = baseTime
	stopped = false

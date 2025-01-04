extends Node

var projectileContainer : Node2D

func _ready():
	projectileContainer = get_tree().get_root().find_child("ProjectileContainer", true, false)
extends Node

var player : CharacterBody2D
var projectileContainer : Node2D

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	projectileContainer = get_tree().get_root().find_child("ProjectileContainer", true, false)
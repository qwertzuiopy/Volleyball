extends Node

var simple_sound = load("res://Sounds/SimpleSound.tscn")

func play(path):
	var instance = simple_sound.instance()
	instance.path = path
	add_child(instance)

func _ready():
	pass

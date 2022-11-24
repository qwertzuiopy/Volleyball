extends Node

var path

func _ready():
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	queue_free()

extends Node2D

func _play():
	var _bla = get_tree().change_scene("res://UI/ControlSetup.tscn")
	click()


func _process(_delta):
	$Camera.position = lerp($Camera.position, get_global_mouse_position() / 10, 0.1)
	if Input.is_action_just_pressed("ui_accept"):
		hover()
		$UI/Play/AnimationPlayer.play("hover")
	if Input.is_action_just_released("ui_accept"):
		_play()

func hover():
	Sound.play("res://Sounds/hover.mp3")

func click():
	Sound.play("res://Sounds/click.mp3")

extends Control

signal stop

var target_value = 0
var act_value = 0

func _init():
	pass

func _process(_delta):
	$Node2D/TextureProgress.value = lerp($Node2D/TextureProgress.value, target_value, 0.1)
# -1 = red, 1 = blue
func update_value(which):
	act_value -= which
	if which == -1:
		$AnimationPlayer.play("red")
	else:
		$AnimationPlayer.play("blue")
	target_value = act_value * 100
	if act_value <= -3:
		emit_signal("stop", "blue")
	elif act_value >= 3:
		emit_signal("stop", "red")

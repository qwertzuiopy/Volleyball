extends Control

# ether 0, 1, 2, 3 or 4
var target_value:int setget update_value

func _init():
	pass

func _process(_delta):
	$Node2D/TextureProgress.value = lerp($Node2D/TextureProgress.value, target_value * 25, 0.1)

func update_value(value):
	$AnimationPlayer.play("OUCH")
	target_value = value

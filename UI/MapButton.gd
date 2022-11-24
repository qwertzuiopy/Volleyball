extends Node2D

var target_scale = 1
export var map:int = 0
export var text:String = "normal"

func _ready():
	$Label.text = text

func _physics_process(_delta):
	$ScaleBuffer.scale = Vector2(1, 1) * lerp($ScaleBuffer.scale.x, target_scale, 0.5)
	if target_scale == 0.7:
		Data.Shake += 1

func _on_BallDetector_body_entered(_body):
	target_scale = 0.7
	$ParticlesExited.emitting = true
	$ParticlesNormal.emitting = false
	$ScaleBuffer/FrameBlue.visible = false
	$ScaleBuffer/FrameRed.visible = true
	$ScaleBuffer/FrameRed/AnimationPlayer.play("loop")


func _on_BallDetector_body_exited(_body):
	target_scale = 1
	$ParticlesExited.emitting = false
	$ParticlesNormal.emitting = true
	$ScaleBuffer/FrameBlue.visible = true
	$ScaleBuffer/FrameRed.visible = false
	$ScaleBuffer/FrameRed/AnimationPlayer.stop()

func play():
	Data.Arena = map
	var _blah = get_tree().change_scene("res://Main.tscn")

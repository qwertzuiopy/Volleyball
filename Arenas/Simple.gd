extends Node2D

signal goal

var origin

func _ready():
	origin = $Camera.position


func _on_DeathLeft_body_entered(_body):
	emit_signal("goal", "blue")
	call_deferred("_reset")
	Data.Shake += 20
	Sound.play("res://Sounds/goal.mp3")
	
func _on_DeathRight_body_entered(_body):
	emit_signal("goal", "red")
	call_deferred("_reset")
	Data.Shake += 20
	Sound.play("res://Sounds/goal.mp3")

func _reset():
	$SquareBall.global_position = Vector2.ZERO
	$SquareBall.linear_velocity = Vector2.ZERO
	$SquareBall.angular_velocity = 0


func _process(delta):
	$Camera.position = $SquareBall.position / 10 + origin


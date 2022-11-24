extends RigidBody2D

const Ball = true
var reset = false
var last

func _init():
	pass

func _integrate_forces(state):
	if reset:
		reset = false
		state.transform = Transform2D(rand_range(-PI,PI), Vector2(0, -88))
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = rand_range(-30,30)
		$SolidTrail.init()

func _bounce(_body):
	Data.Shake += (last-linear_velocity).length() / 30
	Sound.play("res://Sounds/ball_bounce.mp3")
	# Data.Shake += 100

func _physics_process(_delta):
	last = linear_velocity

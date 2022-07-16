extends RigidBody2D

const Ball = true
var reset = false

func _init():
	pass

func _integrate_forces(state):
	if reset:
		reset = false
		state.transform = Transform2D(rand_range(-PI,PI), Vector2(0, -88))
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = rand_range(-30,30)
		$SolidTrail.init()



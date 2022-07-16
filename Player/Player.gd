extends RigidBody2D

export var walk_speed_ground:float
export var walk_speed_air:float

export var damp_x:float

export var max_speed_x:float

export var initial_jump_strength:float
export var air_jump_strength:float
export var max_jump_time:float
export var max_air_jumps:int

export var dash_strength:float
export var dash_time:float

export var down_strength:float

export var standing_strength:float

export var hiting_power:float
export var hiting_power_upwards:float

export var action_left:String
export var action_right:String
export var action_jump:String
export var action_down:String
export var action_dash:String

onready var GroundDetector = $GroundDetector

var jumps = 0
var jumping = false
var dashing
var Ball

var left_eye_speed
var left_eye_distance

var right_eye_speed
var right_eye_distance

const Player = true

func _init():
	left_eye_speed = rand_range(0.01, 0.3)
	left_eye_distance = rand_range(1, 4)
	right_eye_speed = rand_range(0.01, 0.3)
	right_eye_distance = rand_range(1, 4)

func _physics_process(_delta):
	var walk = Input.get_action_strength(action_left) - Input.get_action_strength(action_right)


	var walk_speed = 0
	
	if GroundDetector.get_overlapping_bodies().size() > 1:
		jumps = max_air_jumps
		walk_speed = walk_speed_ground
	else:
		walk_speed = walk_speed_air

	if walk > 0 && linear_velocity.x > -max_speed_x:
		apply_central_impulse(Vector2.LEFT * walk * walk_speed)
	elif walk < 0 && linear_velocity.x < max_speed_x:
		apply_central_impulse(Vector2.LEFT * walk * walk_speed)
	
	if Input.is_action_just_pressed(action_jump) and (jumps > 0 or jumps == 100):
		if jumps != 100:
			jumps -= 1
		apply_central_impulse(Vector2.UP * initial_jump_strength)
		linear_velocity.y = min(linear_velocity.y, -initial_jump_strength)
		jumping = true
		$JumpTimer.start(max_jump_time)
		
		$JumpEffect.start()
	elif Input.is_action_just_released(action_jump):
		$JumpTimer.stop()
		jumping = false
	elif Input.is_action_just_pressed(action_dash):
		var dashDirection = Vector2(-walk, Input.get_action_strength(action_down)-Input.get_action_strength(action_jump))
		
		apply_central_impulse(dashDirection.normalized() * dash_strength)
	elif Input.is_action_just_pressed(action_down):
		apply_central_impulse(Vector2.DOWN * down_strength)
	if jumping:
		apply_central_impulse(Vector2.UP * air_jump_strength)
	
	
	if walk > -0.05 and walk < 0.05:
		apply_central_impulse(Vector2.LEFT * linear_velocity.x * damp_x)
	
	apply_torque_impulse(( - rotation) * standing_strength)
	
	
	$EyeContainer/EyeLeft.global_position = lerp($EyeContainer/EyeLeft.global_position, $EyeLeftTarget.global_position, left_eye_speed)
	$EyeContainer/EyeRight.global_position = lerp($EyeContainer/EyeRight.global_position, $EyeRightTarget.global_position, right_eye_speed)
	
	if $EyeContainer/EyeLeft.global_position.distance_to($EyeLeftTarget.global_position) > left_eye_distance:
		$EyeContainer/EyeLeft.global_position = set_distance($EyeContainer/EyeLeft.global_position, $EyeLeftTarget.global_position, left_eye_distance)
	if $EyeContainer/EyeRight.global_position.distance_to($EyeRightTarget.global_position) > right_eye_distance:
		$EyeContainer/EyeRight.global_position = set_distance($EyeContainer/EyeRight.global_position, $EyeRightTarget.global_position, right_eye_distance)

func set_distance(setPos, tarPos, distance):
	var angle = tarPos.angle_to_point(setPos)
	setPos = Vector2.LEFT.rotated(angle) * distance + tarPos
	return setPos

func _on_Player_body_entered(body):
	if "Ball" in body:
		body.apply_central_impulse((body.global_position-global_position).normalized()*hiting_power)
		body.apply_central_impulse(Vector2.UP*hiting_power_upwards)


func stop_jump():
	jumping = false

func stop_dashing():
	dashing = false

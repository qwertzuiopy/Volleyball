extends RigidBody2D

export var walk_speed_ground:float
export var walk_speed_air:float

export var damp_x:float

export var max_speed_x:float

export var initial_jump_strength:float
export var air_jump_strength:float
export var max_jump_time:float
export var max_air_jumps:int

export var down_strength:float

export var standing_strength:float

export var hiting_power:float
export var hiting_power_upwards:float

export var action_left:String
export var action_right:String
export var action_jump:String
export var action_down:String

onready var GroundDetector = $GroundDetector

export var dasheffect:Resource

var jumps = 0
var jumping = false

var dashing = ""
var dash_time = 0.3

var Ball

var left_eye_speed
var left_eye_distance

var right_eye_speed
var right_eye_distance


var side = "red"
var number = "1"
var prefix = ""


const Player = true

func _init():
	left_eye_speed = rand_range(0.01, 0.3)
	left_eye_distance = rand_range(1, 4)
	right_eye_speed = rand_range(0.01, 0.3)
	right_eye_distance = rand_range(1, 4)
	
func _ready():
	if side == "red":
		$Body.texture = load("res://Bilder/orange_player.png")
		$EyeContainer/EyeLeft.texture = load("res://Bilder/orange_eye.png")
		$EyeContainer/EyeRight.texture = load("res://Bilder/orange_eye.png")
		$ParticleTrail.texture = load("res://Bilder/Effects/orange.png")
		$JumpEffect/Particles.texture = load("res://Bilder/Effects/orange.png")
	elif side == "blue":
		$Body.texture = load("res://Bilder/blue_player.png")
		$EyeContainer/EyeLeft.texture = load("res://Bilder/blue_eye.png")
		$EyeContainer/EyeRight.texture = load("res://Bilder/blue_eye.png")
		$ParticleTrail.texture = load("res://Bilder/Effects/blue.png")
		$JumpEffect/Particles.texture = load("res://Bilder/Effects/blue.png")
	$Label.text = String(number)

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
		
		Sound.play("res://Sounds/jump.wav")
	elif Input.is_action_just_released(action_jump):
		$JumpTimer.stop()
		jumping = false
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
	
	if dashing == "left" && Input.is_action_just_pressed(action_left) && !InputMap.has_action(prefix + "e") || InputMap.has_action(prefix + "e") && Input.is_action_just_pressed(prefix + "e") && walk > 0:
		call_deferred("dash", "left")
		dashing = ""
	if dashing == "right" && Input.is_action_just_pressed(action_right) && !InputMap.has_action(prefix + "e") || InputMap.has_action(prefix + "e") && Input.is_action_just_pressed(prefix + "e") && walk < 0:
		call_deferred("dash", "right")
		dashing = ""
	
	if Input.is_action_just_pressed(action_left) && dashing == "":
		dashing = "left"
		$DashTimer.start(dash_time)
	elif Input.is_action_just_pressed(action_right) && dashing == "":
		dashing = "right"
		$DashTimer.start(dash_time)
	

func set_distance(setPos, tarPos, distance):
	var angle = tarPos.angle_to_point(setPos)
	setPos = Vector2.LEFT.rotated(angle) * distance + tarPos
	return setPos

func dash(w):
	var from = global_position
	if w == "left":
		$DashRay.cast_to = Vector2(-20, 0)
		$DashRay.force_raycast_update()
		if $DashRay.is_colliding():
			if $DashRay.get_collider().has_method("apply_central_impulse"):
				$DashRay.get_collider().apply_central_impulse(Vector2.LEFT * 200)
			global_position = $DashRay.get_collision_point() + Vector2(5, 0)
		else:
			apply_central_impulse(Vector2.LEFT * 150)
			global_position += Vector2(-20, 0).rotated(rotation)
	else:
		$DashRay.cast_to = Vector2(20, 0)
		$DashRay.force_raycast_update()
		if $DashRay.is_colliding():
			if $DashRay.get_collider().has_method("apply_central_impulse"):
				$DashRay.get_collider().apply_central_impulse(Vector2.RIGHT * 200)
			global_position = $DashRay.get_collision_point() + Vector2(-5, 0)
		else:
			apply_central_impulse(Vector2.RIGHT * 150)
			global_position += Vector2(20, 0).rotated(rotation)
	var to = global_position
	var instance = dasheffect.instance()
	get_parent().add_child(instance)
	instance.global_position = Vector2.ZERO
	instance.get_node("Line2D").points[0] = from
	instance.get_node("Line2D").points[1] = to
	if side == "blue":
		instance.get_node("Line2D").texture = load("res://Bilder/Effects/blue.png")
	else:
		instance.get_node("Line2D").texture = load("res://Bilder/Effects/orange.png")
	
	Sound.play("res://Sounds/dash.mp3")

func _on_Player_body_entered(body):
	if "Ball" in body:
		body.apply_central_impulse((body.global_position-global_position).normalized()*hiting_power)
		body.apply_central_impulse(Vector2.UP*hiting_power_upwards)


func stop_jump():
	jumping = false

func stop_dashing():
	dashing = ""

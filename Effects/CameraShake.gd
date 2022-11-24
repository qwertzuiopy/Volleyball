extends Camera2D

var amount = 1
var timescale = 50
var shakescale = 0.1
var time = 0
var offset_x
var offset_y
var timescale_x
var timescale_y

func _init():
	randomize()
	offset_x = rand_range(0, 2 * PI)
	offset_y = rand_range(0, 2 * PI)
	timescale_x = rand_range(0.9, 1.1)
	timescale_y = rand_range(0.9, 1.1)

func _process(delta):
	time += delta
	offset = Vector2(sin(time*timescale*timescale_x+offset_x)*amount*shakescale, sin(time*timescale*timescale_y+offset_y)*amount*shakescale)
	amount += Data.Shake
	Data.Shake = 0

func _physics_process(_delta):
	amount = lerp(amount, 0, 0.1)

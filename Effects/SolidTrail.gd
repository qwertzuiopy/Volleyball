extends Node2D

export(float) var distance = 5.0
export(float) var speed = 10.0
onready var line = $Node/Line2D;
var points = [];

func _ready():
	init()

func init():
	points.clear()
	for i in line.get_point_count():
		points.append(get_global_position());
		line.set_point_position(i, points[i]);

func _physics_process(_delta):
	points[0] = get_global_position();
	line.set_point_position(0, points[0]);
	for i in range(1, points.size()):
		if points[i-1].distance_to(points[i]) > distance:
			var angle = points[i-1].angle_to_point(points[i])
			points[i]  = Vector2.LEFT.rotated(angle) * distance + points[i-1]
		#points[i] += (points[i - 1] - points[i]) * (points[i-1].distance_to(points[i]) - distance) / speed;
		line.set_point_position(i, points[i]);
	

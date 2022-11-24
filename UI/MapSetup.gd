extends Node2D

var Players
var playerCount

export var player_scene:Resource

func _ready():
	# get_tree().change_scene("res://Main.tscn")
	Players = []
	playerCount = Data.Controls.size()
	for i in range(0, playerCount):
		Players = Players + [player_scene.instance()]
		Players[i].action_left = Data.Controls[i] + "l"
		Players[i].action_right = Data.Controls[i] + "r"
		Players[i].action_down = Data.Controls[i] + "d"
		Players[i].action_jump = Data.Controls[i] + "j"
		Players[i].prefix = Data.Controls[i]
		if i < playerCount / 2:
			Players[i].side = "red"
		else:
			Players[i].side = "blue"
		Players[i].number = i + 1
		$ScaleBuffer/Players.add_child(Players[i])
	

func _process(_delta):
	# $Camera.position = lerp($Camera.position, get_global_mouse_position() / 10, 0.1)
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene("res://UI/TitleScreen.tscn")

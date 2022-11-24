extends Node2D

var sufixes
var prefixes
var origin

func _init():
	sufixes = ["l", "r", "j", "d"];
	prefixes = ["s0", "s1", "s2", "s3", "s4", "s5", "s6"];
func _ready():
	origin = $Camera.position

func _process(_delta):
	if Input.is_action_just_pressed("space"):
		_on_Ok_mouse_entered()
	if Input.is_action_just_released("space"):
		_on_Ok_pressed()
	if Input.is_action_just_pressed("esc"):
		_on_Ok_mouse_entered()
	if Input.is_action_just_released("esc"):
		_on_Cancel_pressed()

	for s in sufixes:
		for p in prefixes.size():
			if Input.is_action_just_pressed(prefixes[p] + s):
				var found = false
				for c in $ScaleBuffer.get_children():
					if c.prefix == p:
						found = true
				if not found:
					var index = 0;
					for c in $ScaleBuffer.get_children():
						index += 1
						if c.prefix == -1:
							c.assign(p, index)
							break
	$Camera.position = lerp($Camera.position, get_global_mouse_position() / 10, 0.1)



func _on_Ok_pressed():
	Data.Controls = []
	for c in $ScaleBuffer.get_children():
		if c.prefix != -1:
			Data.Controls = Data.Controls + [prefixes[c.prefix]]
	var _bleh = get_tree().change_scene("res://UI/MapSetup.tscn")
	Sound.play("res://Sounds/click.mp3")


func _on_Cancel_pressed():
	var _blah = get_tree().change_scene("res://UI/TitleScreen.tscn")
	Sound.play("res://Sounds/click.mp3")


func _on_Ok_mouse_entered():
	Sound.play("res://Sounds/hover.mp3")

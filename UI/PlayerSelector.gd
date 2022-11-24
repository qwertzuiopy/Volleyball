extends TextureButton

var sufixes
var prefix
var index
var controls
func _init():
	sufixes = ["l", "r", "j", "d"]
	prefix = -1
	controls = ["W A S D", "Arrow Keys", "Controller 1", "Controller 2", "8 4 5 6", "I J K L", "T F G H"]

func assign(w, n):
	prefix = w
	index = n
	$Which.text = "Player "+String(index)
	$Controls.text = controls[prefix]
	$Plus.visible = false
	Sound.play("res://Sounds/goal.mp3")

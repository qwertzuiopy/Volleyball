extends Node2D

export var currentItem:int
export var itemPrefix:String = "Sprite"

export var animation_distance:float = 50

onready var Label = $Label

var itemCount

var last
var next
var animating = false
var target

func _ready():
	itemCount = Label.get_child_count()
	update_label()

func update_label():
	for i in range(0, itemCount):
		Label.get_child(i).visible = false
	
	Label.get_child(currentItem).visible = true

func _physics_process(delta):
	if animating:
		last.position.x = lerp(last.position.x, target, 0.1)
		next.position.x = lerp(next.position.x, 0, 0.1)
		if next.position.x < 0.1 && next.position.x > -0.1:
			animating = false
			next.position.x = 0
			update_label()

func _arrow_left_pressed():
	last = Label.get_child(currentItem)
	
	currentItem -= 1
	if currentItem < 0:
		currentItem = itemCount - 1
	
	next = Label.get_child(currentItem)
	next.visible = true
	next.position.x = 50
	target = -50
	animating = true
	
	# update_label()

func _arrow_left_released():
	pass

func _arrow_right_pressed():
	last = Label.get_child(currentItem)
	
	currentItem += 1
	if currentItem == itemCount:
		currentItem = 0
	
	next = Label.get_child(currentItem)
	next.visible = true
	next.position.x = -50
	target = 50
	animating = true
	
	# update_label()
func _arrow_right_released():
	pass






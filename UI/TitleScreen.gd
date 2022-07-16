extends Node2D

func _ready():
	$UI/ArenaSellector.currentItem = Data.Arena
	$UI/ArenaSellector.update_label()
	
	$UI/BallSellector.currentItem = Data.Ball
	$UI/BallSellector.update_label()

func _play():
	Data.Arena = $UI/ArenaSellector.currentItem
	Data.Ball = $UI/BallSellector.currentItem
	var _bla = get_tree().change_scene("res://Main.tscn")

extends Node

export(NodePath) var Player0Path
export(NodePath) var Player1Path

export(NodePath) var Player0SpawnPath
export(NodePath) var Player1SpawnPath


export var gameOverTime:float = 3

export(Array, Resource) var Arenas
export(Resource) var player_scene

var Players
var playerCount = 0
var PlayerSpawns

var arena

onready var goal_bar = get_node("%GoalBar")

func _ready():
	var ArenaInstance = Arenas[Data.Arena].instance()
	$"../Arena".add_child(ArenaInstance)
	arena = get_node("../Arena").get_child(0)

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
		$"../Players".add_child(Players[i])
	
	_reset_players()
	arena.connect("goal", self, "_goal")


func _reset_players():
	var spawns = arena.get_node("Spawns").get_children()
	for p in Players:
		spawns = arena.get_node("Spawns").get_children()
		var s = 0
		while s < spawns.size()-1:
			if p.side == "red" && spawns[s].isRed || p.side == "blue" && !spawns[s].isRed:
				p.global_position = spawns[s].global_position
				p.linear_velocity = Vector2.ZERO
				spawns.remove(s)
				s = max(0, s - 1)
			s += 1

func dead(_w):
	var _blah = get_tree().change_scene("res://UI/MapSetup.tscn")

func _goal(w):
	if w == "red":
		goal_red()
	else:
		goal_blue()
	call_deferred("_reset_players")

func goal_red():
	goal_bar.update_value(-1)
func goal_blue():
	goal_bar.update_value(1)

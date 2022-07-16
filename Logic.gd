extends Node

export(NodePath) var Player0Path
export(NodePath) var Player1Path

export(NodePath) var BallSpawnPath
export(NodePath) var Player0SpawnPath
export(NodePath) var Player1SpawnPath


export var gameOverTime:float = 3

export(Array, Resource) var Balls
export(Array, Resource) var Arenas

var Ball
var Player0
var Player1

var BallSpawn
var Player0Spawn
var Player1Spawn

var arena

func _ready():
	var BallInstance = Balls[Data.Ball].instance()
	$"../Ball".add_child(BallInstance)
	var ArenaInstance = Arenas[Data.Arena].instance()
	$"../Arena".add_child(ArenaInstance)

	Ball = $"../Ball".get_child(0)
	Player0 = get_node(Player0Path)
	Player1 = get_node(Player1Path)
	
	BallSpawn = get_node(BallSpawnPath)
	Player0Spawn = get_node(Player0SpawnPath)
	Player1Spawn = get_node(Player1SpawnPath)
	
	$"../UI/GoalBarLeft".target_value = 0
	$"../UI/GoalBarRight".target_value = 0
	
	_update_arena()
	
	$"../Camera".global_position = arena.get_node("Camera").global_position
	$"../Camera".zoom = arena.get_node("Camera").zoom
	
	reset()


func _update_arena():
	arena = $"../Arena".get_child(0)
	arena.DeathLeft.connect("body_entered", self, "_on_death_left")
	arena.DeathRight.connect("body_entered", self, "_on_death_right")

func _on_death_left(_body):
	$"../UI/GoalBarRight".target_value += 1
	reset()

func _on_death_right(_body):
	$"../UI/GoalBarLeft".target_value += 1
	reset()

func reset():
	
	if $"../UI/GoalBarLeft".target_value >= 4 || $"../UI/GoalBarRight".target_value >= 4:
		var _bla = get_tree().change_scene("res://UI/TitleScreen.tscn")
	
	Ball.reset = true
	
	Player0.set_deferred("global_position", Player0Spawn.global_position)
	Player0.set_deferred("linear_velocity", Vector2.ZERO)
	Player0.set_deferred("global_rotation", 0)
	
	Player1.set_deferred("global_position", Player1Spawn.global_position)
	Player1.set_deferred("linear_velocity", Vector2.ZERO)
	Player1.set_deferred("global_rotation", 0)

extends Node2D
@onready var player_spawn: Marker2D = $PlayerSpawn


var player_scene :PackedScene = preload("res://actors/hermitcrab/crab.tscn")
const YOUWIN = preload("res://ui/youwin.tscn")

func _ready() -> void:
	SignalBus.game_won.connect(gamewon)
	var spawn_position = player_spawn.global_position
	var player = player_scene.instantiate()
	player.global_position = spawn_position
	add_child(player)
	SignalBus.ui_updated.emit()

func gamewon() -> void:
	print("Game was won!")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_packed(YOUWIN)
	

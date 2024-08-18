extends Node2D

@onready var player_spawn: Marker2D = $PlayerSpawn
var player_scene :PackedScene = preload("res://actors/hermitcrab/crab.tscn")

func _ready() -> void:
	var spawn_position = player_spawn.global_position
	var player = player_scene.instantiate()
	player.global_position = spawn_position
	add_child(player)
	SignalBus.ui_updated.emit()
	

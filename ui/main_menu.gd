extends Control

@export var main_game_scene : PackedScene = preload("res://maps/main.tscn")



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_game_scene)

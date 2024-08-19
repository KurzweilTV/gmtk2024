extends Control

@export var main_game_scene : PackedScene = preload("res://maps/main.tscn")
@export var main_menu_scene : PackedScene = load("res://ui/main_menu.tscn")


func _on_playagain_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_game_scene)


func _on_mainmenu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

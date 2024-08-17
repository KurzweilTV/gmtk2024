extends Control

@onready var try_again_button: Button = $PanelContainer/VBoxContainer/TryAgainButton
var main_game_scene : PackedScene = preload("res://maps/beach.tscn")



func _on_try_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_game_scene)
	self.queue_free()

extends Control

@onready var try_again_button: Button = $PanelContainer/MarginContainer/VBoxContainer/TryAgainButton
var main_game_scene : PackedScene = preload("res://maps/main.tscn")


func _on_try_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	self.queue_free()

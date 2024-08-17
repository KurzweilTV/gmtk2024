extends Control

@onready var food_bar: ProgressBar = $CanvasLayer/PanelContainer/MarginContainer/HBoxContainer/FoodBar
var gameover_scene = preload("res://ui/gameover.tscn")

func _ready() -> void:
	SignalBus.ui_updated.connect(update_ui)
	print("Signal: update_ui connected...")
	SignalBus.gameover.connect(show_gameover)
	print("Signal: gameover connected...")
	update_ui()
	
func update_ui() -> void:
	food_bar.value = Player.food

func show_gameover() -> void:
	var gameover_ui = gameover_scene.instantiate()
	add_child(gameover_ui)
	get_tree().paused = true

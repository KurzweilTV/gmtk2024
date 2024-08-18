extends Control

@onready var gameover: Control = $CanvasLayer/Gameover
@onready var food_bar: ProgressBar = $CanvasLayer/PanelContainer/MarginContainer/HBoxContainer/FoodBar

func _ready() -> void:
	SignalBus.ui_updated.connect(update_ui)
	print("Signal: update_ui connected...")
	SignalBus.gameover.connect(show_gameover)
	print("Signal: gameover connected...")
	update_ui()
	
func update_ui() -> void:
	food_bar.value = Player.food

func show_gameover() -> void:
	gameover.show()
	get_tree().paused = true

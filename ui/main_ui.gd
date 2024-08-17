extends Control

@onready var food_bar: ProgressBar = $CanvasLayer/PanelContainer/MarginContainer/HBoxContainer/FoodBar


func _ready() -> void:
	SignalBus.ui_updated.connect(update_ui)
	print("Signal: update_ui connected...")
	update_ui()
	
func update_ui() -> void:
	food_bar.value = Player.food

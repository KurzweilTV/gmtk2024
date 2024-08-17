extends Control

@onready var food_bar: ProgressBar = $CanvasLayer/PanelContainer/MarginContainer/HBoxContainer/FoodBar


func _ready() -> void:
	SignalBus.ui_updated.connect(update_ui)
	update_ui()
	
func update_ui() -> void:
	print("Food Changed to: " + str(Player.food))
	food_bar.value = Player.food

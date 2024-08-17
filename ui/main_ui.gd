extends Control

@onready var food_bar: ProgressBar = $CanvasLayer/PanelContainer/MarginContainer/HBoxContainer/FoodBar


func _ready() -> void:
	update_ui()
	
func update_ui() -> void:
	food_bar.value = Player.food

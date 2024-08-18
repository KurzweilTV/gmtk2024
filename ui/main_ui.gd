extends Control

@onready var gameover: Control = $CanvasLayer/Gameover
@onready var food_bar: ProgressBar = $CanvasLayer/PlayerStatus/MarginContainer/HBoxContainer/FoodBar

@onready var speed_label: Label = $CanvasLayer/DEBUG/GridContainer/SpeedLabel
@onready var shell_size_label: Label = $CanvasLayer/DEBUG/GridContainer/ShellSizeLabel
@onready var zoom_label: Label = $CanvasLayer/DEBUG/GridContainer/ZoomLabel

func _ready() -> void:
	SignalBus.ui_updated.connect(update_ui)
	SignalBus.gameover.connect(show_gameover)
	SignalBus.new_zoom.connect(update_debug_ui)
	update_ui()
	
func _process(delta: float) -> void:
	speed_label.text = str(Player.speed * Player.shell_size)
	shell_size_label.text = str(Player.shell_size)
	
func update_debug_ui(zoom) -> void:
	zoom_label.text = str(zoom)
	
	
func update_ui() -> void:
	food_bar.value = Player.food

func show_gameover() -> void:
	gameover.show()
	get_tree().paused = true

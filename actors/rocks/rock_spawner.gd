extends StaticBody2D


@export var food_scene: PackedScene
@export var tutorial_rock : bool = false
@onready var food_groups : Array[Node2D] = [$FoodGroup1, $FoodGroup2, $FoodGroup3]

var shell_children = []
var spawn_chance : float = 0.4

func _ready() -> void:
	get_shell_children()
	spawn_food()
	spawn_shell()

func get_shell_children():
	for child in get_children():
		if child.is_in_group("shell"):
			shell_children.append(child)

func spawn_food() -> void:
	if not tutorial_rock:
		for group in food_groups:
			if randf_range(0, 1) > spawn_chance:
				group.queue_free()
	else:
		for group in food_groups:
			group.queue_free()

func spawn_shell() -> void:
	if not tutorial_rock:
		for shell in shell_children:
			if randf_range(0, 1) > spawn_chance:
				shell.queue_free()
	else:
		for shell in shell_children:
			shell.queue_free()

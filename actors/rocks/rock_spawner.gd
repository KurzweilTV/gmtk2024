extends StaticBody2D


@export var food_scene: PackedScene
@export var tutorial_rock : bool
@onready var food_groups : Array = [$FoodGroup1, $FoodGroup2, $FoodGroup3]

var spawn_chance : float = 0.6

func _ready() -> void:
	if not tutorial_rock:
		for group in food_groups:
			if randf_range(0, 1) < spawn_chance:
				group.show()

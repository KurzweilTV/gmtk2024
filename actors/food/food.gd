extends Area2D

@export var food_value : int = 10

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("change_food"):
		body.change_food(food_value)
		self.queue_free()

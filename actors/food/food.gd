extends Area2D

@export var food_value : int = 2
@onready var collect_sound: AudioStreamPlayer = $CollectSound

func animate_collection(body : CharacterBody2D) -> void:
	var target = self.position + Vector2(500,-500)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target, 1)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("change_food"):
		body.change_food(food_value)
		animate_collection(body)
		collect_sound.play()
		await get_tree().create_timer(1).timeout
		self.queue_free()

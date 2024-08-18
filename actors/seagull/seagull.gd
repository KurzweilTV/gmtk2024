extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	self.scale = Vector2(5,5)

func emit_warning() -> void:
	SignalBus.player_warning.emit()

func attack() -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	self.queue_free()

func _on_beak_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		printerr("Player was hit!")
		body.die()

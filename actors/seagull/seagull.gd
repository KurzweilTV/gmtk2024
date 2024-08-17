extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func emit_warning() -> void:
	SignalBus.player_warning.emit()

func attack() -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	self.queue_free()

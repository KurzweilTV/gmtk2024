extends Area2D

@export var shell_scale : float = 1.0
@onready var debug_label: Label = $DebugLabel

func _ready() -> void:
	SignalBus.new_shell.connect(set_upgrade_arrows)
	self.scale = Vector2(shell_scale, shell_scale)
	set_upgrade_arrows(Player.shell_size)
	debug_label.text = "DEBUG: " + str(Player.shell_size)

func set_upgrade_arrows(new_size) -> void:
	if shell_scale > new_size:
		%Upgrade.show()
		%Downgrade.hide()
	elif shell_scale == new_size:
		%Upgrade.hide()
		%Downgrade.hide()
	else:
		%Upgrade.hide()
		%Downgrade.show()
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("update_player_scale"):
		var player : CharacterBody2D = body
		player.update_player_scale(shell_scale)
		SignalBus.new_shell.emit(shell_scale)
		self.queue_free()

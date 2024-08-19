extends Area2D

@export var shell_scale : float = 1.0
@export var story_shell : bool = false
@onready var debug_label: Label = $DebugLabel

var max_upgrade := 1.6
var max_downgrade := -0.2


func _ready() -> void:
	if not story_shell:
		SignalBus.new_shell.connect(setup_new_shells)
		self.scale = Vector2(shell_scale, shell_scale)
		setup_new_shells(Player.shell_size)
		debug_label.text = "DEBUG: " + str(Player.shell_size)
	else: 
		self.scale = Vector2(shell_scale, shell_scale)
		

func setup_new_shells(new_size) -> void:
	var new_shell_size = Player.shell_size + randf_range(max_downgrade, max_upgrade)
	shell_scale = new_shell_size
	self.scale = Vector2(shell_scale, shell_scale)
	
	if shell_scale > new_size: #sets if the in world shells are an upgrade or not
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

extends CharacterBody2D

@export_category("Player")
@export var initial_speed : int = 30
@export var max_food : int = 100
@export var food_tick : int = -1
@export var starting_player_scale : float = 1.0
@export_category("Seagull")
@export var min_attack_time : float = 10.0
@export var max_attack_time : float = 30.0

@onready var sprite : AnimatedSprite2D = $Sprite 
@onready var autoshadow : AnimatedSprite2D = $Sprite/AutoShadow
@onready var camera: Camera2D = $Camera2D

var tutorial_complete = false
var hiding = false
var dead = false
var seagull_scene = preload("res://actors/seagull/Seagull.tscn")

# System Functions

func _ready() -> void:
	SignalBus.player_warning.connect(show_warning)
	Player.speed = initial_speed
	Player.food = max_food
	Player.shell_size = starting_player_scale
	self.show()
	self.scale = Vector2(starting_player_scale, starting_player_scale) # set initial scale for player
	dead = false
	Player.food = 10
	
func get_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func update_animation(direction: Vector2):
	if direction != Vector2.ZERO and not hiding and not dead: #animation based on movement
		sprite.play("walk")
		
		# Flip based on direction
		if direction.x < 0:
			sprite.flip_h = true
			autoshadow.flip_h = true
			
		elif direction.x > 0:
			sprite.flip_h = false
			autoshadow.flip_h = false
	else:
		if not hiding and not dead:
			sprite.play("idle")
			autoshadow.play("idle")

func _physics_process(_delta):
	var direction = get_input()
	if not hiding and not dead: # stop moving while hiding
		velocity = direction * (Player.speed * (Player.shell_size / 0.8)) # walk faster when you're bigger
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	update_animation(direction)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("hide") and not hiding:
		hide_in_shell()
	elif Input.is_action_just_released("hide") and hiding:
		stop_hiding()


### Gameplay Functions

func hide_in_shell() -> void:
	var hitbox = $Collision
	hiding = true
	sprite.play("hide")
	autoshadow.play("hide")
	hitbox.disabled = true

func stop_hiding() -> void:
	var hitbox = $Collision
	sprite.play("appear")
	autoshadow.play("appear")
	await sprite.animation_finished
	hiding = false
	hitbox.disabled = false
	
func change_food(amount: int) -> void:
	Player.food += amount
	SignalBus.ui_updated.emit()
	
	if Player.food > max_food:
		Player.food = max_food
	elif Player.food <= 0:
		starve()
	
func start_food_timer() -> void:
	$FoodTimer.start()
	
func start_attack_timer() -> void:
	var attack_time = randf_range(min_attack_time, max_attack_time)
	$AttackTimer.wait_time = attack_time
	$AttackTimer.start()

func update_player_scale(size: float) -> void:
	Player.shell_size = size
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(size, size), 2)
	update_camera_zoom()

func update_camera_zoom() -> void:
	
	var new_zoom_value: float = 10 / Player.shell_size
	var new_zoom: Vector2 = Vector2(clamp(new_zoom_value, 1, 10), clamp(new_zoom_value, 1, 10))
	
	SignalBus.new_zoom.emit(new_zoom)

	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", new_zoom, 2)

func leave_safe_cove() -> void:
	print("Leaving Safe Area")
	tutorial_complete = true
	start_food_timer()
	start_attack_timer()

func die() -> void:
	dead = true
	sprite.hide()
	await get_tree().create_timer(1.5).timeout
	SignalBus.gameover.emit()
	
func starve() -> void:
	if not dead:
		dead = true
		sprite.stop()
		sprite.play("die")
		await get_tree().create_timer(1.5).timeout
		SignalBus.gameover.emit()

func show_gameover() -> void:
	pass

# Signal Functions

func show_warning() -> void:
	$WarningLabel.show()
	await get_tree().create_timer(1).timeout
	$WarningLabel.hide()

func _on_food_timer_timeout() -> void:
	change_food(food_tick)
	
func _on_attack_timer_timeout() -> void:
	var seagull = seagull_scene.instantiate()
	add_child(seagull)
	seagull.attack()
	start_attack_timer()

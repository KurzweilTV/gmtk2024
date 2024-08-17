extends CharacterBody2D

@export var speed : int = 50
@export var max_food : int = 100
@export var food_tick : int = -1
@export var player_scale : float = 1.0

@onready var sprite : AnimatedSprite2D = $Sprite
@onready var autoshadow : AnimatedSprite2D = $Sprite/AutoShadow

var hiding = false

# System Functions

func _ready() -> void:
	self.scale = Vector2(player_scale, player_scale)
	start_food_timer()

func get_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func update_animation(direction: Vector2):
	if direction != Vector2.ZERO and not hiding: #animation based on movement
		sprite.play("walk")
		
		# Flip based on direction
		if direction.x < 0:
			sprite.flip_h = true
			autoshadow.flip_h = true
			
		elif direction.x > 0:
			sprite.flip_h = false
			autoshadow.flip_h = false
	else:
		if not hiding:
			sprite.play("idle")
			autoshadow.play("idle")

func _physics_process(_delta):
	var direction = get_input()
	velocity = direction * (speed * clamp(player_scale, 0.5, 3.0)) # walk faster when you're bigger
	if not hiding: # stop moving while hiding
		move_and_slide()
		update_animation(direction)

func _unhandled_input(event: InputEvent) -> void:
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
		SignalBus.gameover.emit() # Player Death signal
	
func start_food_timer() -> void:
	$FoodTimer.start()

# Signal Functions

func _on_food_timer_timeout() -> void:
	change_food(food_tick)

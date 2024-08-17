extends CharacterBody2D

@export var speed = 50
@onready var sprite : AnimatedSprite2D = $Sprite

var hiding = false

func get_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func update_animation(direction: Vector2):
	if direction != Vector2.ZERO and not hiding: #animation based on movement
		sprite.play("walk")
		
		# Flip based on direction
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
	else:
		if not hiding:
			sprite.play("idle")

func _physics_process(_delta):
	var direction = get_input()
	velocity = direction * speed
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
	hitbox.disabled = true

func stop_hiding() -> void:
	var hitbox = $Collision
	sprite.play("appear")
	await sprite.animation_finished
	hiding = false
	hitbox.disabled = false
	

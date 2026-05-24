extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

signal healthChanged

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var effects = $Effects
@onready var hurtBox = $hurtBox
@onready var hurtTimer = $hurtTimer

@onready var currentHealth: int = maxHealth
@export var maxHealth: int = 5

@export var knockbackPower: int = 500
@export var inventory: Inventory

var isHurt: bool = false
var spawnPosition: Vector2

func _ready():
	effects.play("RESET")
	
	# SAVE START POSITION
	spawnPosition = global_position
	
	# UPDATE HEARTS AT START
	healthChanged.emit(currentHealth)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jumping")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	currentHealth -= 1
	
	if currentHealth < 0:
		currentHealth = 0

	healthChanged.emit(currentHealth)

	# PLAYER DIES
	if currentHealth == 0:
		die()
		return

	isHurt = true

	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()

	await hurtTimer.timeout

	effects.play("RESET")
	isHurt = false

func die():
	# RESET PLAYER POSITION
	global_position = spawnPosition
	currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	velocity = Vector2.ZERO

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)

func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_exited(area: Area2D) -> void:
	pass

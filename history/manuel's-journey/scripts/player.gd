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

var isHurt: bool = false

func _ready():
	effects.play("RESET")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	
@export var inventory: Inventory

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth <= 0:
		currentHealth = 0
		
	healthChanged.emit(currentHealth)
	isHurt = true
		
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
		
func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	print_debug(velocity)
	print_debug(position)
	move_and_slide()
	print_debug(position)
	print_debug("  ")


func _on_hurt_box_area_exited(area: Area2D) -> void: 
	pass

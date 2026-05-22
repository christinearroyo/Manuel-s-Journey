extends Area2D

@onready var timer = $Timer

const SPEED = 60

var direction = 1
@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	position.x += direction * SPEED * delta
	if animated_sprite.frame * delta == 0 * delta:
		collision_shape_2d.disabled = true
	if animated_sprite.frame * delta == 4 * delta:
		collision_shape_2d.disabled = false
	
	

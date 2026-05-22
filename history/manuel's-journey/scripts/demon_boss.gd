extends Area2D

@onready var timer = $Timer

const SPEED = 60
const collision_distance = 11

var direction = -1
@onready var collision_shape_2d: CollisionShape2D = $Killzone/CollisionShape2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
		collision_shape_2d.position.x -= collision_distance*2
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
		collision_shape_2d.position.x += collision_distance*2
	position.x += direction * SPEED * delta
	

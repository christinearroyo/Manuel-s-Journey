extends Node2D

const SPEED = 60
const collision_distance = 11

var direction = -1
var damage = 4

@onready var collision_shape_2d: CollisionShape2D = $DemonBossHitBox/CollisionShape2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
		collision_shape_2d.position.x -= collision_distance*2
		animated_sprite_2d_2.position.x -= collision_distance*2
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
		collision_shape_2d.position.x += collision_distance*2
		animated_sprite_2d_2.position.x += collision_distance*2
	position.x += direction * SPEED * delta

func get_damage():
	return damage

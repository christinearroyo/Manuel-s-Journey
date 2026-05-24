extends Node2D

const SPEED = 60
const collision_distance = 40

var damage = 3
var direction = 1

@onready var collision_shape_2d: CollisionShape2D = $GolemHitbox/CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $GolemHitbox/CollisionShape2D2
@onready var collision_shape_2d_3: CollisionShape2D = $GolemHitbox/CollisionShape2D3
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
func _ready() -> void:
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = true
	collision_shape_2d_3.disabled = true
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
		collision_shape_2d.position.x -= collision_distance*2
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		collision_shape_2d.position.x += collision_distance*2
	position.x += direction * SPEED * delta
	if animated_sprite.frame * delta == 0:
		collision_shape_2d_2.disabled = true
		collision_shape_2d_3.disabled = true
	if animated_sprite.frame * delta == 5 * delta:
		collision_shape_2d.disabled = false
	if animated_sprite.frame * delta == 7 * delta:
		collision_shape_2d.disabled = true
	if animated_sprite.frame * delta == 16 * delta:
		collision_shape_2d_2.disabled = false
		collision_shape_2d_3.disabled = false

func get_damage():
	return damage

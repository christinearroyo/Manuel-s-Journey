extends Node2D

const SPEED = 60
var health = 4
var direction = 1
var damage = 1

@onready var collision_shape_2d: CollisionShape2D = $SlimeHitbox/CollisionShape2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_sprite: AnimatedSprite2D = $HealthSprite
	
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta
	if health == 0:
		animated_sprite.play("death")
		if animated_sprite.frame * delta == 1 * delta:
			queue_free()

func _on_slime_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "FireHitbox":
		var fireball = area.get_parent()
		health -= fireball.get_damage()
		if health < 1:
			health = 0
		health_sprite.frame = health
		fireball.hit_enemy()

func get_damage():
	return damage

extends Node2D

var SPEED = 200
var direction = 1
var hit = false
var damage = 2
@onready var animated_sprite_2d: AnimatedSprite2D = $FireHitbox/CollisionShape2D/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if !hit:
		position.x += direction * SPEED * delta
	else:
		animated_sprite_2d.play("hit")
		if animated_sprite_2d.frame * delta == 5 * delta:
			queue_free()
			
func set_direction(_direction: int):
	direction = _direction

func _on_fire_hitbox_body_entered(_body: Node2D) -> void:
	hit = true
	animation_player.play("hitSound")
	
func get_damage():
	return damage

func hit_enemy():
	hit = true
	animation_player.play("hitSound")

extends Node2D

const SPEED = 60
const collision_distance = 85

var health = 20
var direction = -1
var damage = 4
var hurt = false

@onready var collision_shape_2d: CollisionShape2D = $HellBossHitbox/CollisionShape2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_sprite: AnimatedSprite2D = $HealthSprite
@onready var health_sprite_2: AnimatedSprite2D = $HealthSprite2
@onready var health_sprite_3: AnimatedSprite2D = $HealthSprite3
@onready var health_sprite_4: AnimatedSprite2D = $HealthSprite4
@onready var health_sprite_5: AnimatedSprite2D = $HealthSprite5
@onready var game_manager: Node = %GameManager

func _ready() -> void:
	collision_shape_2d.disabled = true
func _process(delta: float) -> void:
	if health != 0:
		if !hurt:
			if ray_cast_right.is_colliding():
				direction = -1
				animated_sprite.flip_h = false
				collision_shape_2d.position.x -= collision_distance*2
			if ray_cast_left.is_colliding():
				direction = 1
				animated_sprite.flip_h = true
				collision_shape_2d.position.x += collision_distance*2
			position.x += direction * SPEED * delta
			if animated_sprite.frame * delta == 27 * delta:
				collision_shape_2d.disabled = false
			if animated_sprite.frame * delta == 29 * delta:
				collision_shape_2d.disabled = true
		else:
			animated_sprite.play("hit")
			if animated_sprite.frame * delta == 4 * delta:
				get_node("HellBossHurtbox").set_deferred("Monitoring", true)
				animated_sprite.play("default")
				hurt = false
	else:
		animated_sprite.play("death")
		if animated_sprite.frame * delta == 17 * delta:
			if game_manager.demon_boss_is_dead:
				game_manager.open_portal7()
			game_manager.hell_boss_died()
			queue_free()
			
func damaged(enemy_damage):
	health -= enemy_damage
	if health < 1:
		health = 0
		animation_player.play("deathSound")
	else:
		animation_player.play("hitSound")
		hurt = true
		get_node("HellBossHurtbox").set_deferred("Monitoring", false)
	if health >= 16:
		health_sprite_5.frame = health - 16
	elif health >= 12:
		health_sprite_5.frame = 0
		health_sprite_4.frame = health - 12
	elif health >= 8:
		health_sprite_4.frame = 0
		health_sprite_3.frame = health - 8
	elif health >= 4:
		health_sprite_3.frame = 0
		health_sprite_2.frame = health - 4
	else:
		health_sprite_2.frame = 0
		health_sprite.frame = health
		
func get_damage():
	return damage
		
func _on_hell_boss_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "FireHitbox":
		var fireball = area.get_parent()
		damaged(fireball.get_damage())
		fireball.hit_enemy()
	if area.name == "SwordHitbox":
		var sword = area.get_parent()
		damaged(sword.get_damage())

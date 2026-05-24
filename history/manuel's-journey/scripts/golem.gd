extends Node2D

const SPEED = 60
const collision_distance = 40
@onready var game_manager: Node = %GameManager

var health = 12
var damage = 3
var direction = 1

@onready var collision_shape_2d: CollisionShape2D = $GolemHitbox/CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $GolemHitbox/CollisionShape2D2
@onready var collision_shape_2d_3: CollisionShape2D = $GolemHitbox/CollisionShape2D3
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_sprite: AnimatedSprite2D = $HealthSprite
@onready var health_sprite_2: AnimatedSprite2D = $HealthSprite2
@onready var health_sprite_3: AnimatedSprite2D = $HealthSprite3

func _ready() -> void:
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = true
	collision_shape_2d_3.disabled = true
func _process(delta: float) -> void:
	if health != 0:
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
	else:
		animated_sprite.play("death")
		if animated_sprite.frame * delta == 3 * delta:
			game_manager.open_portal5()
			queue_free()

func damaged(enemy_damage):
	health -= enemy_damage
	if health < 1:
		health = 0
		animation_player.play("deathSound")
	else:
		animation_player.play("hitSound")
		get_node("GolemHurtbox").set_deferred("Monitoring", false)
	if health >= 8:
		health_sprite_3.frame = health - 8
	elif health >= 4:
		health_sprite_3.frame = 0
		health_sprite_2.frame = health - 4
	else:
		health_sprite_2.frame = 0
		health_sprite.frame = health
		
func get_damage():
	return damage

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hitSound":
		get_node("GolemHurtbox").set_deferred("Monitoring", true)
		

func _on_golem_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "FireHitbox":
		var fireball = area.get_parent()
		damaged(fireball.get_damage())
		fireball.hit_enemy()
	if area.name == "SwordHitbox":
		var sword = area.get_parent()
		damaged(sword.get_damage())

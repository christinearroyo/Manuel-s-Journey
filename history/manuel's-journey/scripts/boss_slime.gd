extends Node2D

const SPEED = 60

var direction = 1
var damage = 2
var health = 8

@onready var game_manager: Node = %GameManager
@onready var collision_shape_2d: CollisionShape2D = $BossSlimeHitbox/CollisionShape2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_sprite_2: AnimatedSprite2D = $HealthSprite2
@onready var health_sprite: AnimatedSprite2D = $HealthSprite

func _process(delta: float) -> void:
	if health != 0:
		if ray_cast_right.is_colliding():
			direction = -1
		if ray_cast_left.is_colliding():
			direction = 1
		if animated_sprite.frame * delta == 0 * delta:
			collision_shape_2d.disabled = true
		if animated_sprite.frame * delta == 4 * delta:
			collision_shape_2d.disabled = false
		position.x += direction * SPEED * delta
		
func damaged(enemy_damage):
	health -= enemy_damage
	if health < 1:
		health = 0
		animation_player.play("deathSound")
	else:
		animation_player.play("hitSound")
		get_node("BossSlimeHurtbox").set_deferred("Monitoring", false)
	if health >= 4:
		health_sprite_2.frame = health - 4
	else:
		health_sprite_2.frame = 0
		health_sprite.frame = health

func get_damage():
	return damage

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hitSound":
		get_node("BossSlimeHurtbox").set_deferred("Monitoring", true)
	if anim_name == "deathSound":
		game_manager.open_portal3()
		queue_free()

func _on_boss_slime_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "FireHitbox":
		var fireball = area.get_parent()
		damaged(fireball.get_damage())
		fireball.hit_enemy()
	if area.name == "SwordHitbox":
		var sword = area.get_parent()
		damaged(sword.get_damage())

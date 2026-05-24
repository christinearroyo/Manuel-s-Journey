extends CharacterBody2D

var SPEED = 130.0
const JUMP_VELOCITY = -300.0
var slime_hit = false
var boss_slime_hit = false
var golem_hit = false
var demon_boss_hit = false
var hell_boss_hit = false
var health = 4
var current_direction = 1
var hurt = false
var has_shield = false
var shield = 4
var magic_damage = 2

const FIREBALL = preload("uid://deplmj5qsqm0x")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword: Node2D = $Sword
@onready var shield_icon: AnimatedSprite2D = $ShieldIcon
@onready var shield_sprite: AnimatedSprite2D = $ShieldSprite
@onready var shield_sprite_2: AnimatedSprite2D = $ShieldSprite2
@onready var shield_sprite_3: AnimatedSprite2D = $ShieldSprite3
@onready var shield_sprite_4: AnimatedSprite2D = $ShieldSprite4
@onready var shields: Array[AnimatedSprite2D] = [shield_icon,shield_sprite,shield_sprite_2,shield_sprite_3,shield_sprite_4]


@export var inventory: Inventory = Inventory.new()

@onready var ui = get_tree().get_first_node_in_group("ui_inventory")


func _ready():
	if inventory:
		inventory.use_item.connect(use_item)
	var hotbar = get_tree().get_first_node_in_group("ui_hotbar")

	if hotbar:
		hotbar.set_inventory(inventory)

	if ui == null:
		print("UI NOT FOUND")
		return

	print("UI FOUND")

	ui.set_inventory(inventory)
	
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_sprite: AnimatedSprite2D = $HealthSprite


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("move_left"):
		if current_direction == 1:
			current_direction = -1
			sword.position.x -= 7*2
			sword.rotation = deg_to_rad(-45)
	if Input.is_action_just_pressed("move_right"):
		if current_direction == -1:
			current_direction = 1
			sword.position.x += 7*2
			sword.rotation = deg_to_rad(45)
		

	# Handle jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if health == 0:
		Engine.time_scale = 0.5
		animated_sprite.play("death")
		if animated_sprite.frame * delta == 3 * delta:
			print("You Died")
			Engine.time_scale = 1.0
			get_tree().call_deferred("reload_current_scene")
	elif Input.is_action_just_pressed("fire"):
		var fireball = FIREBALL.instantiate()
		if current_direction == 1:
			fireball.position.x = position.x + 17
		else:
			fireball.get_node("FireHitbox/CollisionShape2D/AnimatedSprite2D").flip_h = true
			fireball.position.x = position.x - 17
		fireball.set_direction(current_direction)
		fireball.set_damage(magic_damage)
		fireball.position.y = position.y - 7
		get_parent().add_child(fireball)
	elif Input.is_action_just_pressed("swing"):
		sword.get_node("SwordHitbox").get_node("CollisionShape2D").disabled = false
		if current_direction == 1:
			animation_player.play("swing_right")
		else:
			animation_player.play("swing_left")
	elif slime_hit:
		animated_sprite.play("hit")
		if animated_sprite.frame * delta == 1 * delta:
			animation_player.play("hitSound")
			slime_hit = false
	elif boss_slime_hit:
		animated_sprite.play("hit")
		if animated_sprite.frame * delta == 1 * delta:
			animation_player.play("hitSound")
			boss_slime_hit = false
	elif golem_hit:
		animated_sprite.play("hit")
		if animated_sprite.frame * delta == 1 * delta:
			animation_player.play("hitSound")
			golem_hit = false
	elif hell_boss_hit:
		animated_sprite.play("hit")
		if animated_sprite.frame * delta == 1 * delta:
			animation_player.play("hitSound")
			hell_boss_hit = false
	else:
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

func use_item(item):

	print("PLAYER USING:", item.name)

	if item:
		item.use(self)
	
func update_shield(current_shields:int):
	for i in shields.size():
		if i <= current_shields and current_shields != 0:
			shields[i].visible = true
		else:
			shields[i].visible = false
func damage_shield(damage):
	shield -= damage
	if shield < 1:
		shield = 0
		has_shield = false
	update_shield(shield)
		
func damage_health(damage):
	health -= damage
	if health < 1:
		health = 0
		animation_player.play("deathSound")
	health_sprite.frame = health
	
func damaged(damage):
	if has_shield:
		if (shield - damage) <= 0:
			damage_health(damage - shield)
			shield = 0
			update_shield(shield)
		else:
			damage_shield(damage)
	else:
		damage_health(damage)
	get_node("Hitbox").set_deferred("Monitoring", false)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventory)
	var enemy = area.get_parent()
	if area.name == "SlimeHitbox":
		slime_hit = true
		damaged(enemy.get_damage())
	if area.name == "BossSlimeHitbox":
		boss_slime_hit = true
		damaged(enemy.get_damage())
	if area.name == "GolemHitbox":
		golem_hit = true
		damaged(enemy.get_damage())
	if area.name == "DemonBossHitBox":
		demon_boss_hit = true
		damaged(enemy.get_damage())
	if area.name == "HellBossHitbox":
		hell_boss_hit = true
		damaged(enemy.get_damage())

func increase_health(health_increase):
	health += health_increase
	if health > 4:
		health = 4
	health_sprite.frame = health
func apply_shield():
	for shield_bar in shields:
		shield_bar.visible = true
	shield = 4
	has_shield = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swing_right" or anim_name == "swing_left":
		sword.get_node("SwordHitbox").get_node("CollisionShape2D").disabled = true
	if anim_name == "hitSound":
		get_node("Hitbox").set_deferred("Monitoring", true)

func upgrade_sword(stats):
	get_node("Sword").upgrade(stats)

func upgrade_magic(stats):
	magic_damage += stats

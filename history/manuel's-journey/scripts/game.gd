extends Node2D

@onready var hearts_container = $CanvasLayer/heartsContainer
@onready var player = $Player

func _ready():
	hearts_container.setMaxHearts(player.maxHealth)
	hearts_container.updateHearts(player.currentHealth)
	player.healthChanged.connect(hearts_container.updateHearts)
	
func _on_inventory_gui_closed() -> void:
	get_tree().paused = false

func _on_inventory_gui_opened() -> void:
	get_tree().paused = true


func _on_merchant_area_entered(area: Area2D) -> void:
	if area.name == "hurtBox":
		get_tree().paused = true
		get_node("Shop/Animation").play("TransIn")

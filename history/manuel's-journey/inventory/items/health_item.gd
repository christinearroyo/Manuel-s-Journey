extends InventoryItem
class_name HealthItem

@export var health_increase: int = 1


func use(player) -> void:

	print("HEALTH ITEM USED")

	if player == null:
		print("PLAYER NULL")
		return

	player.increase_health(health_increase)

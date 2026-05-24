extends Area2D

@export var itemRes: InventoryItem

func collect(inventory):
	if inventory == null:
		push_error("Inventory is NULL! Did you assign it in the Player?")
		return

	if inventory.has_method("insert"):
		inventory.insert(itemRes)

	queue_free()

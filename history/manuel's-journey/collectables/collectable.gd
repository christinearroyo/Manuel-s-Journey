extends Area2D

@export var itemRes: InventoryItem

func collect():
	queue_free()

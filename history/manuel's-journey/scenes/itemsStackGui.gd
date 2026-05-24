extends Panel
class_name ItemStackGui

@onready var itemSprite: Sprite2D = $item
@onready var amountLabel: Label = $Label

var inventorySlot: InventorySlot


func update():

	if inventorySlot == null or inventorySlot.is_empty():

		itemSprite.visible = false
		amountLabel.visible = false

		return

	itemSprite.visible = true
	itemSprite.texture = inventorySlot.item.texture

	# ONLY SHOW STACK NUMBER IF > 1
	if inventorySlot.amount > 1:

		amountLabel.visible = true
		amountLabel.text = str(inventorySlot.amount)

	else:

		amountLabel.visible = false

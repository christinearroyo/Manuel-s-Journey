extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")

var itemStackGui: ItemStackGui
var index: int
var inventory_gui


func insert(gui_item: ItemStackGui):

	itemStackGui = gui_item
	backgroundSprite.frame = 1

	if itemStackGui.get_parent():
		itemStackGui.get_parent().remove_child(itemStackGui)

	container.add_child(itemStackGui)


func takeItem():

	if !itemStackGui:
		return null

	var item = itemStackGui
	container.remove_child(itemStackGui)
	itemStackGui = null
	backgroundSprite.frame = 0
	return item


func _pressed():


	if inventory_gui.item_in_hand == null:

		if inventory.slots[index] == null:
			inventory.slots[index] = InventorySlot.new()
			return

		if inventory.slots[index].item == null:
			return

		inventory_gui.item_in_hand = inventory.slots[index]
		inventory_gui.old_index = index

		inventory_gui.set_mouse_item(inventory.slots[index])

		# SAFE CLEAR (NO NULLS)
		inventory.slots[index] = InventorySlot.new()


	else:

		var held = inventory_gui.item_in_hand
		var target = inventory.slots[index]
		var old_index = inventory_gui.old_index

		inventory.slots[index] = held

		if old_index != -1:
			inventory.slots[old_index] = target

		inventory_gui.item_in_hand = null
		inventory_gui.old_index = -1

		inventory_gui.set_mouse_item(null)

	inventory.updated.emit()


func _gui_input(event):

	if event is InputEventMouseButton and event.pressed:

		if event.button_index == MOUSE_BUTTON_RIGHT:

			if inventory_gui.item_in_hand != null:

				inventory.slots[inventory_gui.old_index] = inventory_gui.item_in_hand

				inventory_gui.item_in_hand = null
				inventory_gui.old_index = -1

				inventory_gui.set_mouse_item(null)

				inventory.updated.emit()

extends Control

signal opened
signal closed

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/itemsStackGui.tscn")

@onready var hotbar_slots = $NinePatchRect/HBoxContainer.get_children()
@onready var inventory_slots = $NinePatchRect/GridContainer.get_children()

@onready var slots = hotbar_slots + inventory_slots

var item_in_hand = null
var old_index = -1

var mouse_item_gui: ItemStackGui

var is_open = false


func _ready():
	connect_slots()
	inventory.updated.connect(update_slots)
	update_slots()


func connect_slots():
	for i in range(slots.size()):
		slots[i].index = i
		slots[i].inventory_gui = self


func update_slots():

	for i in range(slots.size()):

		var slot_data = inventory.slots[i]

		if slot_data == null or slot_data.item == null:

			if slots[i].itemStackGui:
				slots[i].takeItem()

			continue

		if !slots[i].itemStackGui:

			var gui = ItemStackGuiClass.instantiate()
			slots[i].insert(gui)

		slots[i].itemStackGui.inventorySlot = slot_data
		slots[i].itemStackGui.update()


func set_mouse_item(slot: InventorySlot):

	if mouse_item_gui:
		mouse_item_gui.queue_free()
		mouse_item_gui = null

	if slot == null or slot.item == null:
		return

	mouse_item_gui = ItemStackGuiClass.instantiate()
	add_child(mouse_item_gui)

	mouse_item_gui.inventorySlot = slot
	mouse_item_gui.update()

	mouse_item_gui.z_index = 999


func _process(delta):

	if mouse_item_gui:
		mouse_item_gui.global_position = get_viewport().get_mouse_position()


func open():
	visible = true
	is_open = true
	opened.emit()


func close():
	visible = false
	is_open = false
	closed.emit()
	
	

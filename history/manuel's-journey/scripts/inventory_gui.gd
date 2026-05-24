extends Control

var inventory: Inventory

@onready var ItemStackGuiClass = preload("res://scenes/itemsStackGui.tscn")

# CONTAINERS
@onready var hotbar_container = $NinePatchRect/HBoxContainer
@onready var inventory_container = $NinePatchRect/GridContainer

# SLOT ARRAYS
var hotbar_slots = []
var inventory_slots = []
var slots = []

# DRAGGING
var item_in_hand: InventorySlot = null
var old_index: int = -1
var mouse_item_gui: ItemStackGui = null

# OPEN/CLOSE
var is_open: bool = false


func _ready():

	# GET ALL SLOT NODES
	hotbar_slots = hotbar_container.get_children()
	inventory_slots = inventory_container.get_children()

	slots = hotbar_slots + inventory_slots

	print("SLOTS FOUND:", slots.size())

	# CONNECT SLOT BUTTONS
	for i in range(slots.size()):

		slots[i].index = i
		slots[i].inventory_gui = self


# =========================
# INVENTORY CONNECTION
# =========================
func set_inventory(inv: Inventory):

	print("SET INVENTORY CALLED")

	inventory = inv

	if inventory == null:
		print("INVENTORY IS NULL")
		return

	# CONNECT UPDATE SIGNAL
	if not inventory.updated.is_connected(update_slots):
		inventory.updated.connect(update_slots)

	update_slots()


# =========================
# UPDATE UI
# =========================
func update_slots():

	print("UPDATE SLOTS RUNNING")

	if inventory == null:
		print("NO INVENTORY")
		return

	for i in range(slots.size()):

		# SAFETY
		if i >= inventory.slots.size():
			continue

		var slot_data = inventory.slots[i]
		var ui_slot = slots[i]

		# EMPTY SLOT
		if slot_data == null or slot_data.is_empty():

			if ui_slot.itemStackGui:
				ui_slot.takeItem()

			continue

		# CREATE UI ITEM
		if not ui_slot.itemStackGui:

			var gui = ItemStackGuiClass.instantiate()
			ui_slot.insert(gui)

		# UPDATE ITEM DATA
		ui_slot.itemStackGui.inventorySlot = slot_data
		ui_slot.itemStackGui.update()


# =========================
# SLOT CLICKING
# =========================
func on_slot_clicked(index: int):

	if inventory == null:
		return

	var clicked_slot = inventory.slots[index]

	# PICK UP
	if item_in_hand == null:

		if clicked_slot.is_empty():
			return

		# CREATE COPY
		item_in_hand = InventorySlot.new()
		item_in_hand.item = clicked_slot.item
		item_in_hand.amount = clicked_slot.amount

		old_index = index

		set_mouse_item(item_in_hand)

		inventory.clear_slot(index)

	# PLACE
	else:

		var temp = InventorySlot.new()

		if not clicked_slot.is_empty():
			temp.item = clicked_slot.item
			temp.amount = clicked_slot.amount

		# PLACE HELD ITEM
		inventory.slots[index].item = item_in_hand.item
		inventory.slots[index].amount = item_in_hand.amount

		# RETURN OLD ITEM
		if old_index != -1:

			inventory.slots[old_index].item = temp.item
			inventory.slots[old_index].amount = temp.amount

		item_in_hand = null
		old_index = -1

		set_mouse_item(null)

	inventory.updated.emit()


# =========================
# MOUSE ITEM
# =========================
func set_mouse_item(slot: InventorySlot):

	if mouse_item_gui:
		mouse_item_gui.queue_free()
		mouse_item_gui = null

	if slot == null or slot.is_empty():
		return

	mouse_item_gui = ItemStackGuiClass.instantiate()
	add_child(mouse_item_gui)

	mouse_item_gui.inventorySlot = slot
	mouse_item_gui.update()

	mouse_item_gui.z_index = 999


func _process(_delta):

	if mouse_item_gui:
		mouse_item_gui.global_position = get_viewport().get_mouse_position()


# =========================
# OPEN/CLOSE
# =========================
func open():
	visible = true
	is_open = true


func close():
	visible = false
	is_open = false

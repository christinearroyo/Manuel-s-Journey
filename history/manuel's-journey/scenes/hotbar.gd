extends Panel

var inventory: Inventory

@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector

var currently_selected: int = 0


func set_inventory(inv: Inventory):

	inventory = inv

	if inventory == null:
		return

	if not inventory.updated.is_connected(update_hotbar):
		inventory.updated.connect(update_hotbar)

	update_hotbar()


func update_hotbar() -> void:

	if inventory == null:
		return

	for i in range(slots.size()):

		if i >= inventory.slots.size():
			continue

		var inventory_slot: InventorySlot = inventory.slots[i]

		slots[i].update_to_slot(inventory_slot)


func move_selector() -> void:

	currently_selected = (currently_selected + 1) % slots.size()

	if selector:
		selector.global_position = slots[currently_selected].global_position

func _unhandled_input(event: InputEvent):

	if inventory == null:
		return

	if event.is_action_pressed("use_item"):
		inventory.use_item_at_index(currently_selected)

	if event.is_action_pressed("move_selector"):
		move_selector()

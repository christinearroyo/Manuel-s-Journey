extends Resource
class_name Inventory

signal updated

@export var slots: Array[InventorySlot]


func insert(item: InventoryItem):

	for slot in slots:
		if slot != null and slot.item == item and slot.amount < item.maxAmountPrStack:
			slot.amount += 1
			updated.emit()
			return

	for slot in slots:
		if slot == null or slot.item == null:
			slot.item = item
			slot.amount = 1
			updated.emit()
			return

	updated.emit()


func swap_slots(a: int, b: int):
	var temp = slots[a]
	slots[a] = slots[b]
	slots[b] = temp
	updated.emit()


func set_slot(index: int, slot: InventorySlot):
	slots[index] = slot
	updated.emit()


func clear_slot(index: int):
	slots[index] = InventorySlot.new()
	updated.emit()

extends Resource
class_name Inventory

signal updated
signal use_item

@export var slot_count: int = 16
var slots: Array[InventorySlot] = []

func _init():
	slots = []
	for i in range(slot_count):
		slots.append(InventorySlot.new())


func insert(item: InventoryItem):

	for slot in slots:
		if slot.item == item and slot.amount < item.maxAmountPrStack:
			slot.amount += 1
			updated.emit()
			return

	for slot in slots:
		if slot.is_empty():
			slot.item = item
			slot.amount = 1

			updated.emit() # 🔥 MUST HAPPEN HERE
			return

	updated.emit()


func clear_slot(index: int):
	if index < 0 or index >= slots.size():
		return
	slots[index].clear()
	updated.emit()


func use_item_at_index(index: int) -> void:

	if index < 0 or index >= slots.size():
		return

	var slot = slots[index]

	if slot == null or slot.is_empty():
		return

	use_item.emit(slot.item)

	# REMOVE ITEM AFTER USE
	slot.amount -= 1

	if slot.amount <= 0:
		slot.clear()

	updated.emit()

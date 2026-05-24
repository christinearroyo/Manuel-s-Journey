extends Button

@onready var container: CenterContainer = $CenterContainer

var itemStackGui: ItemStackGui
var index: int
var inventory_gui


func insert(gui_item: ItemStackGui):
	itemStackGui = gui_item

	if itemStackGui.get_parent():
		itemStackGui.get_parent().remove_child(itemStackGui)

	container.add_child(itemStackGui)


func takeItem():
	if itemStackGui == null:
		return

	container.remove_child(itemStackGui)
	itemStackGui = null


func _pressed():
	inventory_gui.on_slot_clicked(index)

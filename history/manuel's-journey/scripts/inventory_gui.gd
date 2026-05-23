extends Control

signal opened
signal closed

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var slots: Array =$NinePatchRect/GridContainer.get_children()

func _ready():
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
	
var isOpen: bool = false
# Called when the node enters the scene tree for the first time.
func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()

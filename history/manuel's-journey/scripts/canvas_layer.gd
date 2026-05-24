extends CanvasLayer

@onready var inventory = $InventoryGUI
@onready var score_label_4: Label = $ScoreLabel4

var coins = 0

func add_point():
	coins += 1
	score_label_4.text = "\n\n Coins: " + str(coins)

func buy(cost):
	coins -= cost
	score_label_4.text = "\n\n Coins: " + str(coins)

func _ready():
	inventory.close()


func _input(event):

	if event.is_action_pressed("toggle_inventory"):

		if inventory.is_open:
			inventory.close()
		else:
			inventory.open()

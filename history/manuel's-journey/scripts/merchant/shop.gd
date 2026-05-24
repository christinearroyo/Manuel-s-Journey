extends CanvasLayer

@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var player: CharacterBody2D = $"../../Player"


var curItem = 0
var select = 0

func switchItem(sel):
	for i in range(Global.items.size()):
		if sel == i:
			curItem = sel
			$Panel/Control/AnimationSprite.play(Global.items[curItem]["Name"])
			$Panel/Control/Name.text = Global.items[curItem]["Name"]
			$Panel/Control/Description.text = Global.items[curItem]["Description"]
			$Panel/Control/Description.text += "\nCost: " + str(Global.items[curItem]["Cost"])

func _on_close_pressed() -> void:
	get_node("Animation").play("TransOut")
	get_tree().paused = false

func _on_next_pressed() -> void:
	switchItem(curItem + 1)

func _on_prev_pressed() -> void:
	switchItem(curItem - 1)

func _on_buy_pressed() -> void:
	var item = Global.items[curItem]
	var cost = item["Cost"]
	if canvas_layer.coins >= cost:
		canvas_layer.buy(cost)
		if item["Name"] == "Character Speed":
			player.SPEED += 100
		if item["Name"] == "Damage":
			pass
		if item["Name"] == "Shield":
			player.apply_shield()
		print("Purchased:", item["Name"])
	else:
		if item["Name"] == "Shield":
			player.apply_shield()
		print("Not enough coins!")

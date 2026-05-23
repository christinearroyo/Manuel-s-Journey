extends CanvasLayer

@onready var game_manager: Node = %GameManager
@onready var score_label: Label = $"../../GameManager/ScoreLabel"
@onready var score_label_2: Label = $"../../GameManager/ScoreLabel2"
@onready var score_label_4: Label = $"../../CanvasLayer/ScoreLabel4"

var curItem = 0
var select = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switchItem(select):
	for i in range(Global.items.size()):
		if select == i:
			curItem = select
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

	if game_manager.score >= cost:
		game_manager.score -= cost
		score_label.text = "You collected " + str(game_manager.score) + " coins."
		score_label_2.text = "Coins: " + str(game_manager.score)
		score_label_4.text = "\n\nCoins: " + str(game_manager.score)
		print("Purchased:", item["Name"])
	else:
		print("Not enough coins!")

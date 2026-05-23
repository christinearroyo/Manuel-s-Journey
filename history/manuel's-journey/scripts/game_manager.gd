extends Node

var score = 0

@onready var game_manager: Node = %GameManager
@onready var score_label: Label = $ScoreLabel
@onready var score_label2: Label = $ScoreLabel2
@onready var score_label4: Label = $"../CanvasLayer/ScoreLabel4"


func add_point():
	score += 1
	
	score_label.text = "You collected " + str(score) + " coins."
	score_label2.text = "You collected " + str(score) + " coins."
	score_label4.text = "\n\n Coins: " + str(score)
	

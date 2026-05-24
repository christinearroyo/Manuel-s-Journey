extends Area2D

@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(_body: Node2D) -> void:
	canvas_layer.add_point()
	animation_player.play("pickup")

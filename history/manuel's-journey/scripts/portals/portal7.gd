extends Area2D



func _on_body_entered(body: Node2D) -> void:
	
	body.global_position = Vector2(0,-250)
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
	
func open():
	monitoring = true
	visible = true

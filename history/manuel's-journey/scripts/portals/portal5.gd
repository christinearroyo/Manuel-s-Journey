extends Area2D

func _on_body_entered(body: Node2D) -> void:
	
	body.global_position = Vector2(-1547,1040)
	
func open():
	monitoring = true
	visible = true

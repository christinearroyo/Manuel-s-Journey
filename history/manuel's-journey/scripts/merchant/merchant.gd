extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		get_tree().paused = true
		get_node("Shop/Animation").play("TransIn")

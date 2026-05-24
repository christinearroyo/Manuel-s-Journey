extends Button


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("")


func _on_pressed() -> void:
	get_tree().quit()

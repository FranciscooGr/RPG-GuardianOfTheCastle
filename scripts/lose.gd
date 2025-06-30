extends Control



func _on_reintentar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn") # Replace with function body.


func _on_salir_pressed() -> void:
	get_tree().quit()

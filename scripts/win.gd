extends Control

func _ready():
	# Supone que el Label está en el mismo nodo
	var points_label = $PointsLabel
	points_label.text = "Puntos Obtenidos: %d" % global.score


func _on_quit_pressed() -> void:
	get_tree().quit()

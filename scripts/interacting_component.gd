extends Node2D

@onready var interact_label: Label = $interact_label
var current_interaction := []
var can_interact := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if current_interaction:
			can_interact = false
			interact_label.hide()
			
			await current_interaction[0].interact.call()
			
			can_interact=true
			
func _process(delta: float) -> void:
	if current_interaction and can_interact:

		current_interaction.sort_custom(_sort_by_nearest)
		var area = current_interaction[0]

		if "is_interactable" in area and area.is_interactable:
			interact_label.text = area.interact_name
			interact_label.show()
		else:
			interact_label.hide()
	else:
		interact_label.hide()

func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist
func _on_interact_range_area_entered(area: Area2D) -> void:
	current_interaction.push_back(area)

func _on_interact_range_area_exited(area: Area2D) -> void:
	current_interaction.erase(area)

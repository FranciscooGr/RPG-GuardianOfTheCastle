extends StaticBody2D

@onready var interactable: Area2D = $interactable
@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animatedSprite2D.frame = 0
	interactable.interact = _on_interact



func _on_interact():
	if animatedSprite2D.frame == 0:
		animatedSprite2D.frame = 1
		interactable.is_interactable = false
		animatedSprite2D.play("open")

		var random_score = randi_range(10, 30)

		# 🔍 Subimos en el árbol hasta el nodo del mundo (Node2D con la función add_score)
		var world = get_tree().current_scene  # O get_parent().get_parent() si está cerca

		if world and world.has_method("add_score"):
			world.add_score(random_score)
			print("✅ ¡Obtuviste ", random_score, " puntos!")
		else:
			print("❌ No se encontró el método add_score en el mundo")

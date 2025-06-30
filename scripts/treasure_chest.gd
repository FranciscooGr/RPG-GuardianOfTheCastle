extends StaticBody2D

@onready var interactable: Area2D = $interactable

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D

@onready var puerta = get_node("../door")  # si están en el mismo nivel

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if animatedSprite2D.frame == 0:
		animatedSprite2D.frame = 1
		interactable.is_interactable = false
		print("Puerta desbloqueada")

		if puerta:
			puerta.unlock()

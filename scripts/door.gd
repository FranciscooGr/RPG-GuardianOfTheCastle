extends StaticBody2D

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var unlocked := false

func unlock():
	if not unlocked:
		unlocked = true
		collision.disabled = true  # desactiva colisión
		if sprite2D:  # si tenés animación
			print("Puerta desbloqueada")

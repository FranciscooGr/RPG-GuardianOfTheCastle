extends CharacterBody2D

var player_chase = false
var player = null
var health = 200
var player_innattack_zone = false
var can_take_damage = true
var is_dead = false
var death_handled = false
var is_hurting = false
var speed := 75  # velocidad del boss (scalar, no vector)

func _physics_process(delta):
	if is_dead and not death_handled:
		handle_death()
		return

	if is_dead:
		return

	deal_with_damage()
	update_health()

	if is_hurting:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if player_chase and player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		$estilo.play("atack")
		$estilo.flip_h = (player.position.x > position.x)
	else:
		velocity = Vector2.ZERO
		$estilo.play("idle")

	move_and_slide()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_innattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_innattack_zone = false

func deal_with_damage():
	if is_dead or is_hurting:
		return

	if player_innattack_zone and global.player_current_atack:
		if can_take_damage:
			health -= 15
			is_hurting = true
			$estilo.play("hurth")
			can_take_damage = false
			$take_damage_cooldown.start()
			print("slime", health)

			if health <= 0:
				is_dead = true
func enemy():
	pass
func handle_death():
	death_handled = true
	$estilo.play("death")
	is_dead = true	
	await $estilo.animation_finished
	queue_free()
	get_tree().change_scene_to_file("res://scenes/win.tscn")
	print("player win")

func update_health():
	var healthbar = $healthbar
	var health_label = $healthbar/healthbar_label  # asegurate del nombre exacto

	# Configura el máximo de la barra (por si no está seteado)
	healthbar.max_value = 200
	healthbar.value = health

	# Mostrar siempre la barra y el texto
	healthbar.visible = true
	health_label.visible = true

	# Mostrar formato: "vida actual / vida máxima"
	health_label.text = "%d / %d" % [health, healthbar.max_value]

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func _on_estilo_animation_finished() -> void:
	if $estilo.animation == "hurth":
		is_hurting = false

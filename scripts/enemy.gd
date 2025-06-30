extends CharacterBody2D

var speed := 35
var player_chase = false
var player = null
var health = 100
var player_innattack_zone = false
var can_take_damage = true
var is_dead = false
var death_handled = false
var is_hurting = false

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
		$AnimatedSprite2D.play("atack")
		$AnimatedSprite2D.flip_h = (player.position.x < position.x)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")

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
			health -= 30
			is_hurting = true
			$AnimatedSprite2D.play("hurth")
			can_take_damage = false
			$take_damage_cooldown.start()
			print("enemy", health)

			if health <= 0:
				is_dead = true

func handle_death():
	death_handled = true
	$AnimatedSprite2D.play("death")
	is_dead = true	
	await $AnimatedSprite2D.animation_finished
	queue_free()
	var world = get_tree().current_scene
	world.add_score(15)  
func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
func enemy():
	pass
	
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	healthbar.visible = health < 100

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "hurth":
		is_hurting = false # Replace with function body.

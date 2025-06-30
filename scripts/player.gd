extends CharacterBody2D

var speed = 100
var current_direction = "none"
var enemy_inattack_range = false
var enemy_atack_cooldown = true
var healt = 100
var player_alive = true
var attack_in_progress = false
var count:int = 0
var maxHealt: int = 100
@onready var health_label = $healthbar/healthbar_label


func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	if healt <= 0:
		$AnimatedSprite2D.play("death")
		player_alive = false
		healt = 0
		print("player kill")
		get_tree().change_scene_to_file("res://scenes/lose.tscn")
		
func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_animation(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_animation(0) 
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_animation(movement):
	var direction = current_direction
	var animation = $AnimatedSprite2D
	
	if current_direction == "right":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("side_idle")
			
			
	if current_direction == "left":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("side_idle")
			
	if current_direction == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("front_idle")
			
	if current_direction == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if attack_in_progress == false:
				animation.play("back_idle")
	


func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_atack_cooldown == true:
		healt -= 15
		enemy_atack_cooldown = false
		$attack_cooldown.start()
		print("Atacando! Salud ahora:", healt)
	

func _on_attack_cooldown_timeout():
	enemy_atack_cooldown = true

func attack():
	var direction = current_direction
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_atack = true
		attack_in_progress = true
		if direction == "right": 
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_atack")
			$deal_attack_timer.start()
		if direction == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_atack")
			$deal_attack_timer.start()
		if direction == "down":
			$AnimatedSprite2D.play("front_atack")
			$deal_attack_timer.start()
		if direction == "up":
			$AnimatedSprite2D.play("back_atack")
			$deal_attack_timer.start()			
			


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_atack = false
	attack_in_progress = false
	
func update_health():
	var healthbar = $healthbar
	var health_label = $healthbar/healthbar_label  

	if healt > maxHealt:
		maxHealt = healt
		healthbar.max_value = maxHealt
	else:
		# maxHealt no baja, se mantiene
		healthbar.max_value = maxHealt

	healthbar.value = min(healt, maxHealt)

	# Actualizamos texto con vida real / máximo base
	health_label.text = "%d / %d" % [healt, maxHealt]

	healthbar.visible = true
	health_label.visible = true
		

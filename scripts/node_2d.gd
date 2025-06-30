extends Node2D
@onready var score_label = $ysort/player/UI/ScoreLabel
@onready var player =  $ysort/player # Ajustá si tenés otro path
var count: int = 0

func add_score(points: int):
	global.score += points
	score_label.text = "Puntos: %d" % global.score

	if global.score >= global.life_reward_threshold:
		count +=1
		reward_extra_life()
		global.next_life_reward += global.life_reward_threshold

func reward_extra_life():
	if player != null and count == 1:
		player.healt += 30  
		print("💚 ¡Vida extra!", player.healt)
		
			
		print("💚 ¡Vida extra!")
	if player != null and count == 2:
		player.speed += 20
		print("segunda recompensa")
	else: 
		print("random recompensa")
		player.healt += 20

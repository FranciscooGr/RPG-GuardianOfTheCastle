extends Area2D

@onready var Enemy_scene = load("res://scenes/enemy.tscn")
@onready var Enemy_scene2 = load("res://scenes/enemy_2.tscn")
var bool_spawn = true

var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()

func _process(delta: float) -> void:
	spawn()

func spawn():
	if bool_spawn:
		$cooldown.start()
		bool_spawn = false
		var enemi_instance = Enemy_scene.instantiate()
		var enemi_instance2 = Enemy_scene2.instantiate()
		enemi_instance.position = Vector2(random.randi_range(6,513), random.randi_range(-173,280))
		add_child(enemi_instance)
		enemi_instance2.position = Vector2(random.randi_range(6,513), random.randi_range(-173,280))
		add_child(enemi_instance2)


func _on_cooldown_timeout() -> void:
	bool_spawn = true

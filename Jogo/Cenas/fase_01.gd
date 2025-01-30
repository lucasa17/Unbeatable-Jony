extends Node2D

var wave : int
var difficulty : float
const  DIFF_multiplier: float = 1.2
var max_enemies : int
var lives : int
var enemiesdead : int
var mundo1 = preload("res://Cenas/Mundo.tscn")
var mundo2 = preload("res://Cenas/Mundo2.tscn")
var mundo3 = preload("res://Cenas/Mundo3.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$GameOver/Button.pressed.connect(new_game)

func new_game():
	wave = 1
	lives = 3
	difficulty = 10.0
	$InimigoSpawner/Timer.wait_time = 1.0
	var intacia0 = mundo1.instantiate()
	$GerenciaMundo.add_child(intacia0)
	reset()

func  reset():
	max_enemies = int(difficulty)
	$Jogador.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("items", "queue_free")
	$Hud/VidaLabel.text = "X " + str(lives)
	$Hud/OndaLabel.text = "ONDA " + str(wave)
	$Hud/InimigosLabel.text = "X " + str(max_enemies)
	$GameOver.hide()
	get_tree().paused = true
	$RestartTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_wave_completed():
		wave += 1
		#ajustar a dificuldade
		difficulty *= DIFF_multiplier
		if $InimigoSpawner/Timer.wait_time > 0.25:
			$InimigoSpawner/Timer.wait_time -= 0.05
		get_tree().paused = true
		$OndaTimer.start()
		if wave >= 2:
			var intacia0 = mundo1.instantiate()
			var intacia1 = mundo2.instantiate()
			var intacia2 = mundo3.instantiate()
			if wave == 4:
				intacia0.queue_free()
				$GerenciaMundo.add_child(intacia1)
			if wave == 8:
				intacia1.queue_free()
				$GerenciaMundo.add_child(intacia2)


func _on_inimigo_spawner_hit_p():
	lives -= 1
	$Hud/VidaLabel.text = "X " + str(lives)
	get_tree().paused = true
	if lives <= 0:
		$GameOver/OndaLabel.text = "Ondas Sobrevividas: " + str(wave - 1)
		$GameOver.show()
	else:
		$OndaTimer.start()


func _on_restart_timer_timeout():
	get_tree().paused = false

func _on_onda_timer_timeout():
	reset()
	

func  is_wave_completed():
	var all_dead = true
	var enemies = get_tree().get_nodes_in_group("enemies")
	# verifica se todos os inimigos spawnaram
	if enemies.size() == max_enemies:
		for e in enemies:
			if e.alive:
				all_dead = false
		return all_dead
	else:
		return false
			
		

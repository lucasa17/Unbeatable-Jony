extends Node2D

@onready var main = get_node("/root/Fase01")

signal hit_p

var  goblin_scene := preload("res://Cenas/goblin.tscn")
var  goblin_scene2 := preload("res://Cenas/goblin2.tscn")
var  goblin_scene3 := preload("res://Cenas/goblin3.tscn")
var  spawn_points := []
var  max_enemiesL : int
var  cont := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
	

func _on_timer_timeout():
	#verifica quantos inimigos foram criados
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() < get_parent().max_enemies:
		#pega um local aleatorio par spawnar o inimigo
		var spawn = spawn_points[randi() % spawn_points.size()]
		#spawna um inimigo
		if cont <= 4  :
			var goblin = goblin_scene.instantiate()
			goblin.position = spawn.position
			goblin.hit_player.connect(hit)
			main.add_child(goblin)
			goblin.add_to_group("enemies")
			
		if cont > 4 and cont <= 15:
			var goblin = goblin_scene2.instantiate()
			goblin.position = spawn.position
			goblin.hit_player.connect(hit)
			main.add_child(goblin)
			goblin.add_to_group("enemies")
			
		if cont > 15:
			var goblin = goblin_scene3.instantiate()
			goblin.position = spawn.position
			goblin.hit_player.connect(hit)
			main.add_child(goblin)
			goblin.add_to_group("enemies")
			
	if enemies.size() == get_parent().max_enemies:
		cont = cont+1

func  hit():
	hit_p.emit()
	cont = cont-1

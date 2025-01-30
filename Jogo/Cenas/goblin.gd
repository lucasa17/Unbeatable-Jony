extends CharacterBody2D

@onready var main = get_node("/root/Fase01")
@onready var player = get_node("/root/Fase01/Jogador")

var explosion_scene := preload("res://Cenas/explosao.tscn")
var item_scene := preload("res://Cenas/item.tscn")

signal  hit_player

var alive : bool
var entered : bool
var speed : int = 100
var direction : Vector2
const DROP_chance : float = 0.05
var enemiesdeadv : int = 0

func _ready():
	var screen_rect = get_viewport_rect()
	entered = false
	alive = true
	#pega a direcao de entrada
	var dist = screen_rect.get_center() - position
	#checa se presisa se movimentar horizontalmente ou verticalmente
	if abs(dist.x) > abs(dist.y):
		#move horizontalmente
		direction.x = dist.x
		direction.y = 0
	else:
		#move vericalmente
		direction.x = 0
		direction.y = dist.y
	
func _physics_process(_delta):
	if alive:
		$AnimatedSprite2D.animation = "teste"
		if entered:
			direction = (player.position - position)
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
		
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass
		
func  die():
	alive = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	if randf() <= DROP_chance:
		drop_item()
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	main.add_child(explosion)
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS
	enemiesdeadv = 1
	

func  drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = randi_range(0,2)
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func _on_entrada_timer_timeout() -> void:
	entered = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	hit_player.emit()

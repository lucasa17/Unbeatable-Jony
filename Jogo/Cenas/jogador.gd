extends CharacterBody2D

signal shoot

const START_speed : int = 200
const BOOST_speed : int = 400
const NORMAL_shot : float = 0.5
const FAST_shot : float = 0.1
var speed : int
var can_shoot : bool
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	reset()

func  reset():
	can_shoot = true
	position = screen_size /2
	speed = START_speed
	$BalaTimer.wait_time = NORMAL_shot

func get_input():
	#teclas do teclado
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed
	
	#mouse vlics
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		$BalaTimer.start()

func _physics_process(_delta):
	#movimento do Jogador
	get_input()
	move_and_slide()
	
	#parede invisivel do mapa
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#Rotacao do Jogador
	
	var mouse = get_local_mouse_position()
	var angle = snapped(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "Andar" + str(angle)
	
	#Animacao do Jogador
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else: 
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
		
	#Teleporte do jogador
	if position.x <= 30:
		position.x = 770
		position.y = 400
	elif position.x >= 780:
		position.x = 50
		position.y = 400
	elif position.y <= 30:
		position.x = 400
		position.y = 735
	elif position.y >= 790:
		position.x = 400
		position.y = 50

func boost():
	$BoostTimer.start()
	speed = BOOST_speed

func quick_fire():
	$FastTimer.start()
	$BalaTimer.wait_time = FAST_shot

func _on_bala_timer_timeout():
	can_shoot = true


func _on_boost_timer_timeout() -> void:
	speed = START_speed


func _on_fast_timer_timeout():
	$BalaTimer.wait_time = NORMAL_shot

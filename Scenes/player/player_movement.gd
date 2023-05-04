class_name Player

extends CharacterBody2D

signal on_player_died

@export var  max_speed: float = 10
@export var rotation_speed: float = 3.5
@export var velocity_damping_factor = .5
@export var linear_acceleration = 200

@onready var invincibility_timer = $InvincibilityTimer
@onready var blinking_timer = $BlinkingTimer
@onready var explosion_particles = $ExplosionParticles
@onready var sprite = $Sprite2D
@onready var enginge_sprite = $EngineSprite
@onready var animation_player = $AnimationPlayer
@onready var engine_audio_player = $EngineAudioPlayer
@onready var explosion_audio_player = $"../ExplosionAudioPlayer"

var input_vector: Vector2
var rotation_direction: int
var is_invincible = false

func _ready():
	blinking_timer.timeout.connect(toggle_visibility)
	invincibility_timer.timeout.connect(stop_invincibility)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_vector.x =  Input.get_action_strength("rotate_left") -  Input.get_action_strength("rotate_right")
	input_vector.y = Input.get_action_strength("thrust")
	
	if Input.is_action_pressed("rotate_left"):
		rotation_direction = -1
	elif Input.is_action_pressed("rotate_right"):
		rotation_direction = 1
	else: 
		rotation_direction = 0
		
	#play_animation 
	if input_vector.y != 0:
		if !engine_audio_player.playing:
			engine_audio_player.play()
		animation_player.play("engine_animation")
	else: 
		if engine_audio_player.playing:
			engine_audio_player.stop()
		animation_player.stop()
		enginge_sprite.visible = false
		
	
	
func _physics_process(delta):
	rotation += rotation_direction * rotation_speed * delta
	
	if (input_vector.y > 0):
		accelerate_forward(delta)	
	elif input_vector.y == 0 && velocity != Vector2.ZERO:
		slow_down_and_stop(delta)
	
	move_and_collide(velocity * delta)
	
	
func accelerate_forward(delta: float):
	velocity += (input_vector * linear_acceleration * delta).rotated(rotation)
	velocity.limit_length(max_speed)

func slow_down_and_stop(delta: float):
		# slow down
		velocity = lerp(velocity, Vector2.ZERO, velocity_damping_factor * delta)
		
		# stop
		if velocity.y >= -0.1 && velocity.y <= 0.1:
			velocity.y = 0


func _on_area_2d_area_entered(area):
	if is_invincible:
		return
	
	if area is Bullet:
		explosion_audio_player.play()
		on_player_died.emit()
		queue_free()
		area.queue_free()
		explosion_particles.emitting = true
		explosion_particles.reparent(get_tree().root)
	
func start_invincibility():
	is_invincible = true
	blinking_timer.start()
	invincibility_timer.start()
	

func toggle_visibility():
	if sprite.visible:
		sprite.visible = false
	else:
		sprite.visible = true
		
func stop_invincibility():
	is_invincible = false
	sprite.visible = true
	blinking_timer.stop()
	invincibility_timer.stop()
	



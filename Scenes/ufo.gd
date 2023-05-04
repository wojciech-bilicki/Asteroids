class_name Ufo

extends Area2D

signal ufo_destroyed

@onready var explosion_particles = $ExplosionParticles
@onready var shooting_timer = $ShootingTimer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@export var bullet_scene: PackedScene
@export var path: PathFollow2D = null
var current_point = 0
var speed = 300
var look_ahead = 5
var visibility_counts = 0
var can_shoot = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	path.progress = .5
	shooting_timer.timeout.connect(shoot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if path == null:
		return
	var progress = delta * speed;
	path.progress += progress

func shoot():
	if !can_shoot:
		return
	audio_player.play()
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.set_collision_layer_value(2, 0)
	bullet.set_collision_layer_value(5, 1)
	
	get_tree().root.add_child(bullet)
	bullet.position = Vector2(global_position)
	bullet.direction = get_random_shot_direction()


func _on_area_entered(area):
	if area is Bullet:
		ufo_destroyed.emit()
		queue_free()
		area.queue_free()
		explosion_particles.emitting = true
		explosion_particles.reparent(get_tree().root)
		

func get_random_shot_direction():
	var node_y = self.get_global_transform().origin.y
	var screen_height = get_viewport().get_visible_rect().size.y 
	# is node in upper half of the screen
	var should_shot_down = node_y <= screen_height / 2
	
	if should_shot_down:
		var angle = deg_to_rad(randf_range(45, 135))
		return Vector2(cos(angle), sin(angle))
	else:
		var angle = deg_to_rad(randf_range(225, 315))
		return Vector2(cos(angle), sin(angle))

func _on_visible_on_screen_notifier_2d_screen_entered():

	visibility_counts += 1
	if visibility_counts == 1:
		can_shoot = true
	else:
		can_shoot = false
		
	if(visibility_counts == 2):
		queue_free()

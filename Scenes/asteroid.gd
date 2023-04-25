class_name Asteroid

extends RigidBody2D

var image_array = ["res://Assets/Asteroid_01.png", "res://Assets/Asteroid_02.png", "res://Assets/Asteroid_03.png", "res://Assets/Asteroid_04.png"]

const Utils = preload("res://Scenes/Utils.gd")

signal on_asteroid_destroyed(size: AsteroidSize, position: Vector2)

var asteroid_scene: PackedScene
@export var speed = 100
@export var speed_increment_factor = .2

var size = Utils.AsteroidSize.BIG

@onready var collision_shape = $CollisionShape2D
@onready var area2D = $Area2D
@onready var area2D_collistion_shape = $Area2D/CollisionShape2D2
@onready var sprite = $Sprite2D as Sprite2D

@onready var explosion_particles = $ExplosionParticles
# Called when the node enters the scene tree for the first time.
func _ready():
	# choose random image
	var scaleValue = 1 / (size + 1.0) 
	
	collision_shape.scale = Vector2(scaleValue, scaleValue)
	area2D.scale = Vector2(scaleValue, scaleValue)
	area2D_collistion_shape.scale = Vector2(scaleValue, scaleValue)
	sprite.scale = Vector2(scaleValue, scaleValue)
	
	speed = speed + speed * size * speed_increment_factor
	
	var random_index = randi() % image_array.size()
	var random_image = load(image_array[random_index])
	sprite.texture = random_image
	
	# get random direction 
	var x = randf_range(-1, 1)
	var y = randf_range(-1, 1)
	var direction = Vector2(x, y)
	linear_velocity = direction.normalized() * speed

func _on_area_2d_area_entered(area):
	
	if area is Bullet:
		emit_explosion()
		queue_free()
		area.queue_free()
		var new_asteroid_size = size + 1
		on_asteroid_destroyed.emit(new_asteroid_size, global_position)
		
func emit_explosion():
	explosion_particles.emitting = true
	explosion_particles.reparent(get_tree().root)





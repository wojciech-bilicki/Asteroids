extends RigidBody2D

enum  AsteroidSize {BIG, MEDIUM, SMALL}
var image_array = ["res://Assets/Asteroid_01.png", "res://Assets/Asteroid_02.png", "res://Assets/Asteroid_03.png", "res://Assets/Asteroid_04.png"]

@export var speed = 100

var size: AsteroidSize = AsteroidSize.BIG

@onready var sprite = $Sprite2D as Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	# choose random image
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
		queue_free()
		area.queue_free()





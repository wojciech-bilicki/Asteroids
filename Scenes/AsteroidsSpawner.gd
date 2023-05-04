class_name  AsteroidSpawner

extends Node

signal points_updated(points: int)
signal game_won;

@export var count: int = 6
@export var asteroid_scene: PackedScene
@export var base_asteroid_points_value = 50
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var total_asteroids_count = 0
var destroyed_asteroids_count = 0;
var points = 0

const Utils = preload("res://Scenes/Utils.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	total_asteroids_count = count * 7
	for i in range(count):
		var random_spawn_position = get_random_position_from_screen_react()
		spawn_asteroid(Utils.AsteroidSize.BIG, random_spawn_position)


func spawn_asteroid(size: Utils.AsteroidSize, position: Vector2):
	var asteroid = asteroid_scene.instantiate() as Asteroid
	get_tree().root.add_child.call_deferred(asteroid)
	asteroid.size = size
	asteroid.global_position = position
	asteroid.on_asteroid_destroyed.connect(asteroid_destroyed)
	
func get_random_position_from_screen_react() -> Vector2:
	var screen_size = get_viewport().size

	# Generate random values for x and y components
	var x = randi_range(0, screen_size.x)
	var y = randi_range(0, screen_size.y)

	# Create a vector from the random values
	var position = Vector2(x, y)
	return position

func asteroid_destroyed(size, position):
	audio_player.play()
	points += base_asteroid_points_value * (size + 1)
	points_updated.emit(points)
	destroyed_asteroids_count += 1
	if destroyed_asteroids_count == total_asteroids_count:
		game_won.emit()
	if(size <= 2):
		for i in range(2):
			spawn_asteroid(size, position)

extends Node

@export var amount: int = 4
@export var asteroid_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(amount):
		spawn_asteroid()


func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate() as RigidBody2D
	get_tree().root.add_child.call_deferred(asteroid)
	asteroid.global_position = get_random_position_from_screen_react()
	
func get_random_position_from_screen_react() -> Vector2:
	var screen_size = get_viewport().size

	# Generate random values for x and y components
	var x = randi_range(0, screen_size.x)
	var y = randi_range(0, screen_size.y)

	# Create a vector from the random values
	var position = Vector2(x, y)
	return position

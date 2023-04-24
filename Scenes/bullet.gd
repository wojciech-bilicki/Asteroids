class_name Bullet

extends Area2D

var direction: Vector2

@export var bullet_speed = 700

func _process(delta):
	position += direction * bullet_speed * delta
	
	
func destroy():
	queue_free()

func _on_area_2d_area_entered(area):
	print(area)
	pass # Replace with function body.

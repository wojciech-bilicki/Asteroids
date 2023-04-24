extends Node

@export var node: Node2D

func _physics_process(delta):
	var screen_size = node.get_viewport_rect().size
	
	if node.global_position.y < 0:
		node.global_position.y = screen_size.y
	elif node.global_position.y > screen_size.y:
		node.global_position.y = 0
		
	if node.global_position.x < 0:
		node.global_position.x = screen_size.x
	elif node.global_position.x > screen_size.x:
		node.global_position.x = 0

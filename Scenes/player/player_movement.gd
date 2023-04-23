extends CharacterBody2D

@export var  max_speed: float = 10
@export var rotation_speed: float = 3.5
@export var velocity_damping_factor = .5

@export var linear_acceleration = 200


var input_vector: Vector2
var rotation_direction: int

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
	
	

func _physics_process(delta):
	rotation += rotation_direction * rotation_speed * delta
	
	if (input_vector.y > 0):
		accelerate_forward(delta)	
	elif input_vector.y == 0 && velocity != Vector2.ZERO:
		slow_down_and_stop(delta)
	
	check_screen_bounds()
	move_and_slide()
	
func accelerate_forward(delta: float):
	velocity += (input_vector * linear_acceleration * delta).rotated(rotation)
	velocity.limit_length(max_speed)

func slow_down_and_stop(delta: float):
		# slow down
		velocity = lerp(velocity, Vector2.ZERO, velocity_damping_factor * delta)
		
		# stop
		if velocity.y >= -0.1 && velocity.y <= 0.1:
			velocity.y = 0

func check_screen_bounds():
	var screen_size = get_viewport_rect().size
	
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
		
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

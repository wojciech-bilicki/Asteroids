class_name  UfoTimer

extends Timer

@export var min_time = 20
@export var max_time = 40 
# Called when the node enters the scene tree for the first time.
func _ready():
	setup_timer()


func setup_timer():
	var timeout_value = randi_range(min_time, max_time)
	self.wait_time = timeout_value
	self.start()
	

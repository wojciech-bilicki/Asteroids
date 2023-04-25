extends CPUParticles2D


# Called when the node enters the scene tree for the first time.

@onready var timer = $Timer

func _ready():
	timer.wait_time = lifetime
	timer.timeout.connect(queue_free)

func _process(delta):
	if emitting && timer.is_stopped():
		timer.start()
		

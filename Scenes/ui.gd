extends CanvasLayer


var life_texture = preload("res://Assets/Lives.png")
var empty_life_texture = preload("res://Assets/Player.png")

@onready var lifes_manager: LifesManager = $"../LifesManager"
@onready var lifes_container: HBoxContainer = $%HBoxContainer
@onready var game_over_label: Label = $%GameOverLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var lifes_count = lifes_manager.lifes
	for i in range(lifes_count):
		var life_texture_rect = TextureRect.new()
		life_texture_rect.texture = life_texture
		lifes_container.add_child(life_texture_rect)
	
	lifes_manager.player_life_lost.connect(life_lost)
		

func life_lost(lifes_left):
	var life_texture_rect: TextureRect =  lifes_container.get_child(lifes_left)
	life_texture_rect.texture = empty_life_texture
	if lifes_left == 0:
		game_over_label.visible = true


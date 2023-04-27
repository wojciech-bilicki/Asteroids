extends Node2D



func _on_start_game_button_pressed():
	load_new_scene("res://Scenes/main.tscn")
	
func load_new_scene(scene_path: String):
	var packed_scene = load(scene_path) as PackedScene
	var new_scene = packed_scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.call_deferred("queue_free")
	get_tree().current_scene = new_scene

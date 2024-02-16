class_name MainMenu extends Control

func _input(event) -> void:
	if event.is_action_pressed("Jump"):
		ResourceStash.game.reset_player = true
		get_tree().change_scene_to_file("res://ui/loading_screen.tscn")

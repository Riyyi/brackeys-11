class_name MainMenu extends Control

func _input(event) -> void:
	if event.is_action_pressed("Jump"):
		get_tree().change_scene_to_file("res://world.tscn")

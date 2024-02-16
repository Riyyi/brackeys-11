class_name GameOver extends Control

var main_menu_scene: PackedScene = preload("res://ui/main_menu.tscn")

func _input(event) -> void:
	if event.is_action_pressed("Jump"):
		get_tree().paused = false # unpause game
		ResourceStash.game.reset()
		get_tree().change_scene_to_packed(main_menu_scene)

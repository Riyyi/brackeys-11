class_name MainMenu extends Control

var loading = false

func _input(event) -> void:
	if loading == false:
		if event.is_action_pressed("Jump"):
			$VBoxContainer/CenterContainer/VBoxContainer.visible = false
			$VBoxContainer/CenterContainer/Loading.visible = true
			ResourceLoader.load_threaded_request("res://world.tscn")
			loading = true

func _process(delta):
	if loading == true:
		var progress = []
		var loading_status = ResourceLoader.load_threaded_get_status("res://world.tscn", progress)
		if loading_status == 3:
			var main_game = ResourceLoader.load_threaded_get("res://world.tscn")
			get_tree().change_scene_to_packed(main_game)
		elif loading_status == 1:
			print("progress ", progress[0])
		elif loading_status == 0:
			print("Invalid scene file")
		elif loading_status == 2:
			print("Failed to load game")

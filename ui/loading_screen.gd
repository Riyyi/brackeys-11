class_name LoadingScreen extends Control

func _ready():
	ResourceLoader.load_threaded_request("res://world.tscn")

func _process(delta):
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

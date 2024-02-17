class_name Fullscreen extends Node

var is_fullscreen: bool = false

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event) -> void:
	if event.is_action_pressed("Pause"):
		var pause: Control = get_node("/root/World/Pause")
		if get_tree().paused == true:
			pause.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
		else:
			if ResourceStash.game.in_world == true:
				pause.visible = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				get_tree().paused = true
	
	if event.is_action_pressed("Focus"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("Unfocus"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("ToggleFullscreen"):
		if is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			is_fullscreen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			is_fullscreen = true

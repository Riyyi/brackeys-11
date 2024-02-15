class_name Fullscreen extends Node

var is_fullscreen: bool = false

func _input(event) -> void:
	if event.is_action_pressed("ToggleFullscreen"):
		if is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_fullscreen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			is_fullscreen = true

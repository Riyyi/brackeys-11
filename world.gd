extends Node3D

var fullscreen: bool = false

var world_generator: WorldGenerator

func _ready():
	world_generator = WorldGenerator.new()
	add_child(world_generator)

func _input(ev) -> void:
	if ev.is_action_pressed("ToggleFullscreen"):
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			fullscreen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			fullscreen = true

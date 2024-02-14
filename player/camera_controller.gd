class_name CameraController extends Node3D

@export var sensitivity: float = 5.0
var forced_rotation = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if forced_rotation == false:
			rotate_camera(event.relative.x, event.relative.y)

func rotate_camera(relative_x: float = 0.0, relative_y: float = 0.0) -> void:
		# Relative:
		# x < 0 = left
		# x > 0 = right
		# y < 0 = upddda
		# y > 0 = down
		var xRotation: float = clamp(rotation.x - relative_y / 1000 * sensitivity, -0.90, 0.90) # Look up/down
		var yRotation: float = rotation.y - relative_x / 1000 * sensitivity # Look left/right
		rotation = Vector3(xRotation, yRotation, 0.0)

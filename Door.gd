extends Node3D

@onready var left_door = $LeftDoor
@onready var right_door = $RightDoor
@onready var world: World = get_node("/root/World")

var current_angle = 0.0
var speed = 3.0
var open = false
var opening = false
var target_angle = 2.5
var door_direction = 1

func open_door(direction):
	if open == false:
		open = true
		opening = true
		door_direction = direction

func _process(delta):
	if opening == true:
		current_angle += (speed * delta)
		if current_angle > 2.5:
			current_angle = 2.5
			opening = false
			world.bake_navmesh() # enemies can follow you into the hallway
		left_door.rotation = Vector3(0.0, (-door_direction) * current_angle, 0.0)
		right_door.rotation = Vector3(0.0, door_direction * current_angle, 0.0)

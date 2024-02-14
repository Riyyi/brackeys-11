extends Node3D

@onready var left_door = $LeftDoor
@onready var right_door = $RightDoor

var current_angle = 0.0
var speed = 3.0
var open = false
var opening = false
var target_angle = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func open_door():
	if open == false:
		open = true
		opening = true

func _process(delta):
	if opening == true:
		current_angle += (speed * delta)
		if current_angle > 2.5:
			current_angle = 2.5
			opening = false
		left_door.global_rotation = Vector3(0.0, current_angle, 0.0)
		right_door.global_rotation = Vector3(0.0, -current_angle, 0.0)

extends Area3D

#@onready var start_position = $StartPosition.global_position
@onready var door = get_parent()
@onready var door_position = get_parent().global_position
@onready var start_position_front = $StartPositionFront
@onready var start_position_back = $StartPositionBack

var triggered = false
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if "Player" in body.name:
		var direction : int
		var start_position : Vector3
		var rot : float
		if body.global_position.distance_squared_to(start_position_front.global_position) < body.global_position.distance_squared_to(start_position_back.global_position):
			direction = -1
			start_position = start_position_front.global_position
			rot = door.global_rotation.y
		else:
			direction = 1
			start_position = start_position_back.global_position
			rot = door.global_rotation.y - PI
		
		while rot < -PI:
			rot += 2*PI
		while rot > PI:
			rot -= 2*PI
		
		if triggered == false:
			body.bash_door(start_position, rot, get_parent())
			triggered = true
		elif triggered == true and opened == false:
			$AudioStreamPlayer.play()
			door.open_door(direction)
			opened = true

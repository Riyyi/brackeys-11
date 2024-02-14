extends Area3D

@onready var start_position = $StartPosition.global_position
@onready var door_position = get_parent().global_position

var triggered = false
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if triggered == false:
		if "Player" in body.name:
			print(Vector2(start_position.x, start_position.z).angle_to(Vector2(door_position.x, door_position.z)))
			body.bash_door(start_position, Vector2(start_position.x, start_position.z).angle_to(Vector2(door_position.x, door_position.z)), get_parent())
			triggered = true
	elif triggered == true and opened == false:
		$AudioStreamPlayer.play()
		get_parent().open_door()
		opened = true

extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	translate(Vector3(0,0,1) * delta * 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
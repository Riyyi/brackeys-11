@tool
extends Camera3D

var item_mesh: Node
var angle = 0.0
var speed = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	item_mesh = get_child(0)
	
func _physics_process(delta):
	angle += delta * speed
	item_mesh.set_rotation_degrees(Vector3(0.0, angle, 0.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@tool class_name ItemCamera extends Camera3D

var item_mesh: Node
var angle: float = 0.0
var speed: float = 100.0

func _ready() -> void:
	item_mesh = get_child(0)
	
func _physics_process(delta) -> void:
	angle += delta * speed
	item_mesh.set_rotation_degrees(Vector3(0.0, angle, 0.0))

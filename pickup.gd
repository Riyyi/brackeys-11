@tool
extends Area3D

@export var Item: PackedScene

func _on_ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var item_cam = $ItemViewport/ItemCamera
	item_cam.global_position = global_position
	item_cam.position.z += 1.5

func _on_body_entered(body):
	body.pickup(Item) # Replace with function body.
	#pass

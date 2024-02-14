@tool
extends Area3D

@export var Item: PackedScene
var hover = 0.0

func _on_ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var item_cam = $ItemViewport/ItemCamera
	item_cam.global_position = global_position
	item_cam.position.z += 1.5
	hover += delta
	$ItemBillboard.position.y = (sin(hover*1.5)/4)

func _on_body_entered(body):
	if "Player" in body.name:
		body.weapon_pickup(Item) # Replace with function body.

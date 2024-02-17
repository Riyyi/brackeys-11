@tool class_name Pickup extends Area3D

@export var item: PackedScene

var hover: float = 0.0

func _ready() -> void:
	body_entered.connect(body_collide)

func _process(delta: float) -> void:
	var item_cam = $ItemViewport/ItemCamera
	item_cam.global_position = global_position
	item_cam.position.z += 1
	hover += delta
	$ItemBillboard.position.y = sin(hover * 1.5) / 4

func body_collide(body: Node3D) -> void:
	if "Player" in body.name:
		body.weapon_pickup(item)

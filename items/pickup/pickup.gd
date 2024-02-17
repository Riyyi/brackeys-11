@tool class_name Pickup extends Area3D

var hover: float = 0.0

func _ready() -> void:
	body_entered.connect(on_body_entered)

func _process(delta: float) -> void:
	var item_cam = $ItemViewport/ItemCamera
	item_cam.global_position = global_position
	item_cam.position.z += 1
	hover += delta
	$ItemBillboard.position.y = sin(hover * 1.5) / 4
	$CollisionShape3D.position.y = sin(hover * 1.5) / 4
	$OmniLight3D.position.y = sin(hover * 1.5) / 4

func on_body_entered(body: Node3D):
	if "Player" in body.name:
		give_player_item(body as Player)
		queue_free()

# Override this function in the inherited scene
func give_player_item(player: Player):
	pass

class_name EnemyWalkState extends State

@onready var player: Player = get_node("/root/World/Player")

func _ready() -> void:
	animation.play("Walk")

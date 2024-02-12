class_name EnemyWalkState extends State

var enemy: Enemy

func _ready() -> void:
	enemy = get_parent()
	animation.play("Walk")

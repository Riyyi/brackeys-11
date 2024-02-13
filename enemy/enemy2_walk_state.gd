class_name Enemy2WalkState extends State

var enemy2: Enemy2

func _ready() -> void:
	enemy2 = get_parent()
	animation.play("Walk")

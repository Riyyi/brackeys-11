class_name EnemyInactiveState extends State

var enemy: Enemy

func _ready() -> void:
	animation.play("Idle")
	
	enemy = get_parent()
	
func _process(_delta) -> void:
	if enemy.has_line_of_sight:
		enemy.change_state(0) # exit inactive state

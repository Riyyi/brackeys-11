class_name EnemyIdleState extends State

var enemy: Enemy

@onready var player: Player = get_node("/root/World/Player")

func _ready() -> void:
	animation.play("Idle")
	enemy = get_parent()

func _physics_process(_delta) -> void:
	# Stop moving
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 1.0)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0.0, 1.0)

	# If player is far away enough, start walking
	var origin1 = player.global_position
	var origin2 = enemy.global_position
	var distance = origin1.distance_to(origin2)
	if distance > enemy.distance_to_begin_walk and not enemy.nav_agent.is_navigation_finished():
		enemy.change_state(1) # Walk towards player
	elif not enemy.has_line_of_sight:
		enemy.change_state(1) # Walk towards player
	else:
		enemy.change_state(2) # Attack

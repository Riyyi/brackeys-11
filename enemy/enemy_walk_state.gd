class_name EnemyWalkState extends State

var enemy: Enemy

@onready var player: Player = get_node("/root/World/Player")

func _ready() -> void:
	animation.play("Walk")
	
	enemy = get_parent()
	enemy.nav_agent.velocity_computed.connect(nav_agent_velocity_computed)
	enemy.nav_agent.target_reached.connect(nav_agent_become_idle)
	enemy.nav_agent.navigation_finished.connect(nav_agent_become_idle)

func _physics_process(_delta) -> void:
	await get_tree().process_frame # Wait 1 frame, for NavigationServer map synchronization
	
	# Enemy is close enough to the player
	if enemy.nav_agent.distance_to_target() < enemy.distance_to_begin_walk and enemy.has_line_of_sight:
		nav_agent_become_idle()
		return
	
	var current_position = enemy.global_position
	var next_position = enemy.nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_position).normalized() * enemy.speed
	
	enemy.nav_agent.velocity = new_velocity
	
func nav_agent_velocity_computed(velocity) -> void:
	enemy.velocity = enemy.velocity.move_toward(velocity, 0.25)
	enemy.move_and_slide()
	
func nav_agent_become_idle() -> void:
	enemy.change_state(0)

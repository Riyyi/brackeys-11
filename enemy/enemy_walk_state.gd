class_name EnemyWalkState extends State

var enemy: Enemy

@onready var player: Player = get_node("/root/World/Player")

func _ready() -> void:
	animation.play("Walk")
	
	enemy = get_parent()
	enemy.nav_agent.target_reached.connect(nav_agent_target_reached)
	enemy.nav_agent.velocity_computed.connect(nav_agent_velocity_computed)

func _physics_process(_delta) -> void:
	await get_tree().process_frame # Wait 1 frame, for NavigationServer map synchronization
	
	enemy.nav_agent.target_position = player.global_position
	
	var current_position = enemy.global_position
	var next_position = enemy.nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_position).normalized() * enemy.speed
	
	enemy.nav_agent.velocity = new_velocity
	
func nav_agent_velocity_computed(velocity) -> void:
	enemy.velocity = enemy.velocity.move_toward(velocity, 0.25)
	enemy.move_and_slide()
	
func nav_agent_target_reached() -> void:
	enemy.change_state(0)

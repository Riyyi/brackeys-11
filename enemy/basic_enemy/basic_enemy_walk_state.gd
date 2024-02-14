class_name BasicEnemyWalkState extends EnemyWalkState

var enemy: BasicEnemy

var acceleration = 7
var speed = 0.5

func _ready() -> void:
	super()
	enemy = get_parent()

func _physics_process(delta) -> void:
	enemy.nav_agent.target_position = player.global_position
	
	var current_position = enemy.global_position
	var next_position = enemy.nav_agent.get_next_path_position()
	var direction = (next_position - current_position).normalized()
	
	enemy.nav_agent.velocity = direction
	enemy.velocity = enemy.velocity.lerp(direction * speed, acceleration * delta)
	enemy.move_and_slide()

	#print(str(enemy.nav_agent.distance_to_target()))

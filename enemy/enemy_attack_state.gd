class_name EnemyAttackState extends State

@onready var player: Player = get_node("/root/World/Player")

var enemy: Enemy
var enemy_gun: EnemyGun
var gun_pointer: Node3D

func exit() -> void:
	enemy_gun.holding_trigger = false

func play_attack(name: String) -> void:
	animation.play("Attack")

# -----------------------------------------

func _ready() -> void:
	animation.play("Idle")
	
	enemy = get_parent()
	gun_pointer = $"../GunPointer"
	enemy_gun = $"../GunPointer/EnemyGun"
	enemy_gun.did_shoot.connect(play_attack)

func _physics_process(delta) -> void:
	# Stop moving
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 1.0)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0.0, 1.0)
	
	enemy_gun.holding_trigger = false
	if not animation.is_playing():
		animation.play("Idle")
	
	# If player is behind wall
	if not enemy.has_line_of_sight:
		enemy.change_state(1) # Walk towards player
		return
		
	# If player is far away
	var origin1 = player.global_position
	var origin2 = enemy.global_position
	var distance = origin1.distance_to(origin2)
	if distance > enemy.distance_to_begin_walk and not enemy.nav_agent.is_navigation_finished():
		enemy.change_state(1) # Walk towards player
		return
	
	# Fire bullet
	var player_waist = player.global_position + Vector3(0, enemy.offset, 0)
	gun_pointer.look_at(player_waist, Vector3.UP, true) # point gun at player
	enemy_gun.holding_trigger = true

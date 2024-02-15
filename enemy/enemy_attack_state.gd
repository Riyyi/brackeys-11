class_name EnemyAttackState extends State

@onready var player: Player = get_node("/root/World/Player")

var enemy: Enemy
var enemy_gun: EnemyGun
var gun_pointer: Node3D
var offset: float = 0.85
var ray_cast: RayCast3D
var ray_length: float = 50

func has_line_of_sight() -> bool:
	var player_waist = player.global_position + Vector3(0, offset, 0)
	var enemy_eye_position = enemy.global_position + Vector3(0, offset, 0)
	var ray_direction = (player_waist - enemy.global_position).normalized() * ray_length
	ray_cast.target_position = ray_direction
	return ray_cast.is_colliding() and "Player" in ray_cast.get_collider().name

func exit() -> void:
	enemy_gun.holding_trigger = false
	if ray_cast is RayCast3D:
		ray_cast.queue_free()

# -----------------------------------------

func _ready() -> void:
	animation.play("Idle")
	
	enemy = get_parent()
	gun_pointer = $"../GunPointer"
	enemy_gun = $"../GunPointer/EnemyGun"
	
	ray_cast = RayCast3D.new()
	ray_cast.global_position.y += 0.85 # Move raycast to eye level
	enemy.add_child(ray_cast)

func _physics_process(delta) -> void:
	# Stop moving
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 1.0)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0.0, 1.0)
	
	enemy_gun.holding_trigger = false
	
	# If player is far away enough, start walking
	var origin1 = player.global_position
	var origin2 = enemy.global_position
	var distance = origin1.distance_to(origin2)
	if distance > enemy.distance_to_begin_walk and not enemy.nav_agent.is_navigation_finished():
		enemy.change_state(1) # Walk towards player
	
	if not has_line_of_sight():
		return
	
	# Fire bullet
	var player_waist = player.global_position + Vector3(0, offset, 0)
	gun_pointer.look_at(player_waist, Vector3.UP, true) # point gun at player
	enemy_gun.holding_trigger = true

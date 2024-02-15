class_name EnemyAttackState extends State

@onready var player: Player = get_node("/root/World/Player")

var enemy: Enemy
var spring_arm_3d: SpringArm3D
var gun_pointer: Node3D
var enemy_gun: EnemyGun
var ray_cast: RayCast3D
var ray_length: float = 50

func has_line_of_sight() -> bool:
	# TODO: Add player.height / 2 to the global_position.y
	var ray_direction = (player.global_position - enemy.global_position).normalized() * ray_length
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
	spring_arm_3d = $"../SpringArm3D"
	gun_pointer = $"../GunPointer"
	enemy_gun = $"../GunPointer/SpringArm3D/EnemyGun"
	
	ray_cast = RayCast3D.new()
	enemy.add_child(ray_cast)
	
	print("ATTACK")


func _physics_process(delta) -> void:
	# Stop moving
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 1.0)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0.0, 1.0)
	
	# If player is far away enough, start walking
	var origin1 = player.global_position
	var origin2 = enemy.global_position
	var distance = origin1.distance_to(origin2)
	if distance > 4:
		enemy.change_state(1)
	
	if not has_line_of_sight():
		enemy_gun.holding_trigger = false
		return
		
	# Fire bullet
	gun_pointer.look_at(player.global_position, Vector3.UP) # point gun at player
	enemy_gun.holding_trigger = true

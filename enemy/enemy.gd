class_name Enemy extends CharacterBody3D

@export var speed: float = 0.75
@export var distance_to_begin_walk: float = 8.0

# Amount of frames in this tilesheet
@export var animation_index: int = 0
@export var h_frames: int = 1
@export var v_frames: int = 1

@onready var animation: AnimationPlayer = %Animation # acces in the child via unique name
@onready var enemy_gun: EnemyGun = $GunPointer/EnemyGun
@onready var eye_left: RayCast3D = $EyeLeft
@onready var eye_right: RayCast3D = $EyeRight
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var nav_agent: NavigationAgent3D = $NavAgent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var player: Player = get_node("/root/World/Player")

var material: StandardMaterial3D
var state: State # current state
var state_factory: StateFactory

var sight_length: float = 50
var offset: float = 0.85
var has_line_of_sight: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func change_state(new_state: int) -> void:
	if state is State:
		state.exit()
		state.queue_free()
		
	# Create State Node
	state = state_factory.get_state(new_state).new(new_state)
	state.setup(animation, self)
	add_child(state)
	
func took_damage(hitbox: HitboxComponent) -> void:
	stats_component.health -= hitbox.damage

# -----------------------------------------

func _ready() -> void:
	var mesh = mesh_instance_3d.mesh as QuadMesh
	material = mesh.material as StandardMaterial3D
	
	state_factory = StateFactory.new([EnemyIdleState, EnemyWalkState, EnemyAttackState, EnemyInactiveState])
	change_state(3)

func _process(_delta) -> void:
	# Apply animation
	var x_index = animation_index % h_frames
	var y_index: int = floor(animation_index / h_frames)
	material.uv1_offset = Vector3(1.0 / h_frames * x_index, 1.0 / v_frames * y_index, 1.0)
	
	nav_agent.target_position = player.global_position
	has_line_of_sight = __has_line_of_sight()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	move_and_slide()
	
# -----------------------------------------

func __has_line_of_sight() -> bool:
	var player_waist = player.global_position + Vector3(0, offset, 0)
	var ray_direction_left = (player_waist - eye_left.global_position ).normalized() * sight_length
	var ray_direction_right = (player_waist - eye_right.global_position ).normalized() * sight_length
	eye_left.target_position = ray_direction_left
	eye_right.target_position = ray_direction_right
	return eye_left.is_colliding() and "Player" in eye_left.get_collider().name and \
		   eye_right.is_colliding() and "Player" in eye_right.get_collider().name

class_name Enemy2 extends Node3D

# Amount of frames in this tilesheet
@export var animation_index: int = 0
@export var h_frames: int = 4
@export var v_frames: int = 5

@onready var animation: AnimationPlayer = $Animation
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var material: StandardMaterial3D
var state: State # current state
var state_factory: StateFactory

func change_state(new_state_name: int) -> void:
	if state is State:
		state.exit()
		state.queue_free()
		
	# Create State Node
	state = state_factory.get_state(new_state_name).new(new_state_name)
	state.setup(animation, self)
	add_child(state)

func _ready() -> void:
	var mesh = mesh_instance_3d.mesh as QuadMesh
	material = mesh.material as StandardMaterial3D
	
	state_factory = StateFactory.new([Enemy2WalkState])
	change_state(0)

func _process(_delta) -> void:
	# Apply animation
	var x_index = animation_index % h_frames
	var y_index: int = floor(animation_index / h_frames)
	material.uv1_offset = Vector3(1.0 / h_frames * x_index, 1.0 / v_frames * y_index, 0)

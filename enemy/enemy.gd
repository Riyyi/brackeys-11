class_name Enemy extends Node3D

@export var animation_column = 0

@onready var animation: AnimationPlayer = $Animation
@onready var sprite_3d: Sprite3D = $Sprite3D

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
	state_factory = StateFactory.new([EnemyWalkState])
	change_state(0)

func _process(_delta) -> void:
	sprite_3d.frame = animation_column

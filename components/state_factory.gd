class_name StateFactory extends Node

var states: Array[GDScript]

func get_state(state: int) -> GDScript:
	assert(state >= 0 and state < states.size(), "Error: State was not found")
	return states[state]

# Constructor
func _init(states_: Array[GDScript]) -> void:
	self.states = states_

# Init
func _ready() -> void:
	pass

# Update
func _process(_delta) -> void:
	pass

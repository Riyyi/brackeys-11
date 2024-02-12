class_name State extends Node

var animation: AnimationPlayer
var persistent_state

func setup(animation, persistent_state) -> void:
	self.animation = animation
	self.persistent_state = persistent_state

func exit() -> void:
	pass

# Constructor
func _init(state: int) -> void:
	pass

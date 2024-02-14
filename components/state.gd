class_name State extends Node

var animation: AnimationPlayer
var persistent_state

func setup(animation_, persistent_state_) -> void:
	self.animation = animation_
	self.persistent_state = persistent_state_

func exit() -> void:
	pass

# Constructor
func _init(_state: int) -> void:
	pass

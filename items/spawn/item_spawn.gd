class_name ItemSpawn extends Node3D

@onready var icon: MeshInstance3D = $Icon

func _ready() -> void:
	icon.visible = Engine.is_editor_hint()

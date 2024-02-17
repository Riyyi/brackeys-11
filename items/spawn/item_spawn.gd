class_name ItemSpawn extends Node3D

@export var type: SpawnType = SpawnType.Loot
enum SpawnType { Gun = 1, Loot = 2 }

@onready var icon: MeshInstance3D = $Icon

func _ready() -> void:
	icon.visible = Engine.is_editor_hint()
	WorldGenerator.add_spawn(self)

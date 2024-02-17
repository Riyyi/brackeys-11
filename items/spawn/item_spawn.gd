class_name ItemSpawn extends Node3D

@export var type: SpawnType
enum SpawnType { Ammo = 0, Gun = 1, Health = 2 }

@onready var icon: MeshInstance3D = $Icon

func _ready() -> void:
	icon.visible = Engine.is_editor_hint()
	#(get_node("root/World") as World).register_spawn.emit(self)
	WorldGenerator.add_spawn(self)

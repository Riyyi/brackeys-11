class_name Gun extends Node3D

signal did_shoot(name: String)

@export var bullet: PackedScene
@export var firerate: float = 10.0

@onready var bangbang = $Bangbang
@onready var bullet_emitter = $BulletEmitter

var firerate_timer: float = 0.0
var has_ammo: bool = true

func shoot() -> void:
	bullet_emitter.add_child(bullet.instantiate())
	bangbang.play()
	did_shoot.emit(name)

func _process(delta) -> void:
	if firerate_timer > (1.0 / firerate):
		if Input.is_action_pressed("LeftClick") and has_ammo:
			shoot()
			firerate_timer = 0.0
	firerate_timer += delta

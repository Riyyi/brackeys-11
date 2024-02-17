class_name Gun extends Node3D

signal did_shoot(name: String)

@export var bullet: PackedScene
@export var firerate: float = 10.0
@export var sound: AudioStream

@onready var bangbang = $Bangbang
@onready var bullet_emitter = $BulletEmitter

var firerate_timer: float = 0.0
var has_ammo: bool = true

func shoot() -> void:
	bullet_emitter.add_child(bullet.instantiate())
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_transform = bullet_emitter.global_transform
	get_tree().root.add_child(bullet_instance)
	bangbang.play()
	did_shoot.emit(name)

func _ready() -> void:
	bangbang.stream = sound

func _process(delta) -> void:
	if firerate_timer > (1.0 / firerate):
		if Input.is_action_pressed("LeftClick") and has_ammo:
			shoot()
			firerate_timer = 0.0
	firerate_timer += delta

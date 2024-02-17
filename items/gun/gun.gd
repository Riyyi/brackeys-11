class_name Gun extends Node3D

signal did_shoot(name: String)

@export var bullet: PackedScene
@export var firerate: float = 10.0
@export var sound: AudioStream

@export var RecoilForce: float = 1.0
@export var MaxRecoil: float = 1.0
@export var RecoilRecoverSpeed: float = 1.0

@onready var bangbang = $Bangbang
@onready var bullet_emitter = $BulletEmitter

var firerate_timer: float = 0.0
var has_ammo: bool = true

var current_recoil = 0.0

func recoil():
	var recoil = RecoilForce * (1 - (current_recoil/MaxRecoil))
	position.z += recoil
	current_recoil += recoil

func recoil_recover():
	var recoil_recovery = (RecoilRecoverSpeed * (current_recoil/MaxRecoil)) * get_process_delta_time()
	position.z -= recoil_recovery
	current_recoil -= recoil_recovery

func shoot() -> void:
	recoil()
	bullet_emitter.add_child(bullet.instantiate())
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_transform = bullet_emitter.global_transform
	get_tree().root.add_child(bullet_instance)
	bangbang.play()
	did_shoot.emit(name)

func _ready() -> void:
	bangbang.stream = sound

func _process(delta) -> void:
	recoil_recover()
	
	if firerate_timer > (1.0 / firerate):
		if Input.is_action_pressed("LeftClick") and has_ammo:
			shoot()
			firerate_timer = 0.0
	firerate_timer += delta

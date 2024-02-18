class_name Gun extends Node3D

signal did_shoot(name: String)

@export var bullet: PackedScene
@export var firerate: float = 10.0
@export var sound: AudioStream

@export var RecoilForce: float = 1.0
@export var MaxRecoil: float = 1.0
@export var RecoilRecoverSpeed: float = 1.0

@onready var bangbang = $Bangbang
@onready var bullet_emitters = $BulletEmitters
@onready var muzzle_flash = $Muzzleflash

var firerate_timer: float = 0.0
var has_ammo: bool = true
var can_shoot: bool = false

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
	if can_shoot == true:
		muzzle_flash.light_energy = 10
		for node in muzzle_flash.get_children():
			node.emitting = true
		recoil()
		for node in bullet_emitters.get_children():
			var bullet_instance = bullet.instantiate()
			bullet_instance.global_transform = node.global_transform
			get_tree().root.add_child(bullet_instance)
		bangbang.play()
		did_shoot.emit(name)

func _ready() -> void:
	firerate_timer = 1.0 / firerate
	bangbang.stream = sound
	muzzle_flash.transform = bullet_emitters.transform

func _process(delta) -> void:
	recoil_recover()
	
	muzzle_flash.light_energy -= delta * 100
	if muzzle_flash.light_energy < 0:
		muzzle_flash.light_energy = 0
	
	if firerate_timer > (1.0 / firerate):
		if Input.is_action_pressed("LeftClick") and has_ammo:
			shoot()
			firerate_timer = 0.0
	firerate_timer += delta

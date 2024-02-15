class_name World extends Node3D

@onready var player: Player = $Player
@onready var hud: Control = $HUD

var health_label: Label
var machinegun_ammo_label: Label
var shotgun_ammo_label: Label

var world_generator: WorldGenerator

func ui_update_health():
	health_label.text = str(player.stats_component.health)

func ui_update_ammo(gun: int, amount: int):
	if gun == 0:
		machinegun_ammo_label.text = str(amount)
	else:
		shotgun_ammo_label.text = str(amount)

# -----------------------------------------

func _ready() -> void:
	health_label = Utils.find_node_by_name(hud, "HealthValue") # via unique name
	machinegun_ammo_label = Utils.find_node_by_name(hud, "MachinegunAmmoValue")
	shotgun_ammo_label = Utils.find_node_by_name(hud, "ShotgunAmmoValue")
	ui_update_health()
	ui_update_ammo(0, player.machinegun_ammo)
	ui_update_ammo(1, player.shotgun_ammo)

	player.stats_component.health_changed.connect(ui_update_health)
	player.ammo_changed.connect(ui_update_ammo)
	
	world_generator = WorldGenerator.new()
	add_child(world_generator)

class_name World extends Node3D

@onready var hud: Control = $HUD
@onready var nav_region = $NavRegion

var player: Player
var health_label: Label
var health_bar: ProgressBar
var machinegun_ammo_label: Label
var shotgun_ammo_label: Label

var world_generator: WorldGenerator

func ui_update_health():
	health_label.text = str(player.stats_component.health)
	health_bar.value = player.stats_component.health

func ui_update_ammo(gun: int, amount: int):
	if gun == 0:
		machinegun_ammo_label.text = str(amount) + " "
	else:
		shotgun_ammo_label.text = str(amount) + " "

func bake_navmesh():
	#await get_tree().process_frame # wait 1 frame, for NavigationServer map synchronization
	nav_region.bake_navigation_mesh(false)

func game_over():
	ResourceStash.game.in_world = false
	var game_over_ui: GameOver = load("res://ui/game_over.tscn").instantiate()
	add_child(game_over_ui)
	get_tree().paused = true # pause game

# -----------------------------------------

func _ready() -> void:
	var did_reset_player: bool = ResourceStash.game.reset_player
	
	ResourceStash.game.in_world = true
	player = ResourceStash.game.spawn_player(self)
	player.global_position.y = 2.5
	player.global_position.z = 15.75
	player.stats_component.no_health.connect(game_over)
	player.stats_component.health_changed.connect(ui_update_health)
	player.ammo_changed.connect(ui_update_ammo)
	
	Utils.find_node_by_name(hud, "ScoreValue").text = str(ResourceStash.game.levelselect - 1)
	Utils.find_node_by_name(hud, "HighScoreValue").text = str(ResourceStash.game.highscore)
	
	health_label = Utils.find_node_by_name(hud, "HealthValue") # via unique name
	health_bar = Utils.find_node_by_name(hud, "HealthBar") # via unique name
	machinegun_ammo_label = Utils.find_node_by_name(hud, "MachinegunAmmoValue")
	shotgun_ammo_label = Utils.find_node_by_name(hud, "ShotgunAmmoValue")
	ui_update_health()
	ui_update_ammo(0, player.machinegun_ammo)
	ui_update_ammo(1, player.shotgun_ammo)
	
	world_generator = WorldGenerator.new(3, 1, did_reset_player)
	nav_region.add_child(world_generator)
	bake_navmesh()

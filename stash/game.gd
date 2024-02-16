class_name Game extends Resource

signal score_changed(new_score: int)

@export var initial_player_health: int = 3
@export var initial_machinegun_ammo: int = 0
@export var initial_shotgun_ammo: int = 0

var score: int = 0: set = set_score
var highscore: int = 0

var player = preload("res://player/player.tscn")
var player_instance: Player
var player_health: int
var machinegun_ammo: int
var shotgun_ammo: int
var gun1: PackedScene
var gun2: PackedScene

var levelselect : int = 1
var reset_player = true

func set_score(value: int):
	score = value
	score_changed.emit(score)

func reset() -> void:
	if player_instance != null:
		player_instance.queue_free()

	player_health = initial_player_health
	machinegun_ammo = initial_machinegun_ammo
	shotgun_ammo = initial_shotgun_ammo
	gun1 = null
	gun2 = null
	
	reset_player = false

func spawn_player(append: Node3D) -> Player:
	if reset_player == true:
		reset()
		
	player_instance = player.instantiate()
	append.add_child(player_instance)
	player_instance.stats_component.health = player_health
	player_instance.machinegun_ammo = machinegun_ammo
	player_instance.shotgun_ammo = shotgun_ammo
	player_instance.gun1 = gun1
	player_instance.gun2 = gun2
	if gun1 != null:
		player_instance.switch_gun(0)
	elif gun2 != null:
		player_instance.switch_gun(1)
	return player_instance
	
func store_player(player_health_: int, machinegun_ammo_: int, shotgun_ammo_: int, gun1_: PackedScene, gun2_: PackedScene) -> void:
	player_health = player_health_
	machinegun_ammo = machinegun_ammo_
	shotgun_ammo = shotgun_ammo_
	gun1 = gun1_
	gun2 = gun2_

class_name Game extends Resource

signal score_changed(new_score: int)

@export var player_health: int = 10
@export var machinegun_ammo: int = 0
@export var shotgun_ammo: int = 0

@export var score: int = 0: set = set_score
@export var highscore: int = 0

var player = preload("res://player/player.tscn")
var player_instance: Player
var gun1: PackedScene
var gun2: PackedScene

func set_score(value: int):
	score = value
	score_changed.emit(score)

func spawn_player(append: Node3D) -> Player:
	if player_instance is Player:
		player_instance.queue_free()
	
	player_instance = player.instantiate()
	append.add_child(player_instance)
	player_instance.stats_component.health = player_health
	player_instance.machinegun_ammo = machinegun_ammo
	player_instance.shotgun_ammo = shotgun_ammo
	player_instance.gun1 = gun1
	player_instance.gun2 = gun2
	return player_instance
	
func store_player(player_health_: int, machinegun_ammo_: int, shotgun_ammo_: int, gun1_: PackedScene, gun2_: PackedScene) -> void:
	player_health = player_health_
	machinegun_ammo = machinegun_ammo_
	shotgun_ammo = shotgun_ammo_
	gun1 = gun1_
	gun2 = gun2_

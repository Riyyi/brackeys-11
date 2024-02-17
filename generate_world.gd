class_name WorldGenerator extends Node

var rng = RandomNumberGenerator.new()

var starting_room_length = 50
var room_width = 50
var room_length = 50
var hallway_width = 150
var hallway_length = 30
var collumns = 3
var rows = 8

var room_scenes: Array[PackedScene]
var hallway: PackedScene
var starting_room: PackedScene
var teleport_room: PackedScene
var starting_hallway: PackedScene
var final_hallway: PackedScene
var loot_room: PackedScene
var big_enemy_room: PackedScene

var starting_room_instance: Node3D
var teleport_room_instance: Node3D
var starting_hallway_instance: Node3D
var final_hallway_instance: Node3D
var loot_room_instance: Node3D
var big_enemy_room_instance: Node3D

var room_instances: Array[Node3D]
var hallway_instances: Array[Node3D]

var did_reset_player: bool = false

# RNG between 0-x, below y is skipped
var loot_spawn_chance: Vector2 = Vector2(100, 50) # Spawn or not
var loot_type_spawn_chance: Vector3 = Vector3(100, 33.3, 66.6) # Health, Machinegun, Shotgun
static var item_spawns: Array[ItemSpawn]

func _init(columns_: int, rows_: int, did_reset_player_: bool):
	name = "Generate"
	collumns = columns_
	rows = rows_
	did_reset_player = did_reset_player_
	item_spawns.clear()

func _ready():
	var dir = DirAccess.open("res://Rooms")
	var rooms = dir.get_files()
	for room in rooms:
		if "StartingRoom" in room:
			starting_room = load(("res://Rooms/" + room).trim_suffix(".remap"))
		elif "TeleportRoom" in room:
			teleport_room = load(("res://Rooms/" + room).trim_suffix(".remap"))
		elif "LootRoom" in room:
			loot_room = load(("res://Rooms/" + room).trim_suffix(".remap"))
		elif "BigEnemyRoom" in room:
			big_enemy_room = load(("res://Rooms/" + room).trim_suffix(".remap"))
		elif "StartingHallway" in room:
			starting_hallway = load(("res://Rooms/" + room).trim_suffix(".remap"))
		elif "FinalHallway" in room:
			final_hallway = load(("res://Rooms/" + room).trim_suffix(".remap"))
		elif "Hallway" in room:
			hallway = load(("res://Rooms/" + room).trim_suffix(".remap"))
		else:
			room_scenes.append(load(("res://Rooms/" + room).trim_suffix(".remap")))
			
	starting_room_instance = starting_room.instantiate()
	add_child(starting_room_instance)
	
	starting_hallway_instance = starting_hallway.instantiate()
	add_child(starting_hallway_instance)
	starting_hallway_instance.global_position.z = -(starting_room_length / 2 + hallway_length / 2)
	
	generate_rooms()
	generate_loot()

func generate_rooms():
	var big_enemy_room_spawned = false
	var loot_room_spawned = false
	
	var rows = ResourceStash.game.levelselect * 1
	
	var teleport_row = rng.randi_range(0, rows - 1)
	var teleport_collumn = rng.randi_range(0, collumns - 1)
	
	var special_count = 2
	
	var row_index = 0
	for row in rows:
		var row_rooms: Array[Node3D]
		
		var collumn_index = 0
		for collumn in collumns:
			if row_index == teleport_row and collumn_index == teleport_collumn:
				teleport_room_instance = teleport_room.instantiate()
				row_rooms.append(teleport_room_instance)
				add_child(teleport_room_instance)
			
			else:
				var rand = rng.randi_range(0, room_scenes.size()-1 + special_count)
				if rand == 0 and big_enemy_room_spawned == false:
					big_enemy_room_instance = big_enemy_room.instantiate()
					row_rooms.append(big_enemy_room_instance)
					add_child(big_enemy_room_instance)
					big_enemy_room_spawned = true
				elif rand == 1 and loot_room_spawned == false:
					loot_room_instance = loot_room.instantiate()
					row_rooms.append(loot_room_instance)
					add_child(loot_room_instance)
					loot_room_spawned = true
				else:
					if rand < special_count:
						rand = rng.randi_range(special_count-1, room_scenes.size()-1 + special_count)
					var room_instance = room_scenes[rand - special_count].instantiate()
					row_rooms.append(room_instance)
					add_child(room_instance)
			
			collumn_index += 1
			
		var room_index = 0
		for room in row_rooms:
			# hard coded for 3 collumns
			room.global_position = Vector3(room_width * room_index - room_width, 0.0, -(starting_room_length / 2 + hallway_length * (row_index + 1) + room_length * row_index + room_length / 2))
			room_index += 1
		
		if row_index == rows - 1:	
			final_hallway_instance = final_hallway.instantiate()
			add_child(final_hallway_instance)
			final_hallway_instance.global_position.z = -(starting_room_length / 2 + hallway_length * (row_index + 1) + room_length * (row_index + 1) + hallway_length / 2)
		else:
			var hallway_instance = hallway.instantiate()
			hallway_instances.append(hallway_instance)
			add_child(hallway_instance)
			hallway_instance.global_position.z = -(starting_room_length / 2 + hallway_length * (row_index + 1) + room_length * (row_index + 1) + hallway_length / 2)
		
		row_index += 1

static func add_spawn(marker: ItemSpawn) -> void:
	item_spawns.append(marker)

func generate_loot():
	var gun_spawns: Array[GunSpawn] = []
	var loot_spawns: Array[ItemSpawn] = []
	for i in range(item_spawns.size()):
		var spawn = item_spawns[i]
		if (spawn.type == ItemSpawn.SpawnType.Gun): gun_spawns.append(spawn)
		if (spawn.type == ItemSpawn.SpawnType.Loot): loot_spawns.append(spawn)
	
	if did_reset_player:
		spawn_pistol(gun_spawns[0])
	
	# Spawn a gun in the loot room, pick one at random
	spawn_random_gun(gun_spawns)
	
	# Spawn Ammo/health
	spawn_ammo_and_health(loot_spawns)

func spawn_pistol(gun_spawn: GunSpawn) -> void:
	var pistol: PistolPickup = load("res://items/pickup/pistol_pickup.tscn").instantiate()
	starting_room_instance.add_child(pistol)
	pistol.global_position = gun_spawn.global_position
	
func spawn_random_gun(gun_spawns: Array[GunSpawn]) -> void:
	var guns: Array[PackedScene] = [
		load("res://items/pickup/machinegun_pickup.tscn"),
		load("res://items/pickup/pistol_pickup.tscn"),
		load("res://items/pickup/shotgun_pickup.tscn")
	]
	for i in range(1, gun_spawns.size()): # Skip first gun, as that is the starting pistol
		var spawn: GunSpawn = gun_spawns[i]
		var gun: int = rng.randi_range(0, guns.size() - 1)
		var gun_pickup: WeaponPickup = guns[gun].instantiate()
		spawn.add_sibling(gun_pickup)
		gun_pickup.global_position = spawn.global_position
	pass

func spawn_ammo_and_health(loot_spawns: Array[ItemSpawn]) -> void:
	var ammo: PackedScene = load("res://items/pickup/ammo_pickup.tscn")
	var health: PackedScene = load("res://items/pickup/health_pickup.tscn")	
	for i in range(loot_spawns.size()):
		var spawn_chance = rng.randf_range(0, loot_spawn_chance[0])
		if spawn_chance < loot_spawn_chance[1]:
			continue
		
		var spawn: ItemSpawn = loot_spawns[i]
		var spawn_type_chance = rng.randf_range(0, loot_type_spawn_chance[0])
		if spawn_type_chance < loot_type_spawn_chance[1]:
			var health_pickup: HealthPickup = health.instantiate()
			spawn.add_sibling(health_pickup)
			health_pickup.global_position = spawn.global_position
		else:
			var ammo_pickup: AmmoPickup = ammo.instantiate()
			spawn.add_sibling(ammo_pickup)
			ammo_pickup.global_position = spawn.global_position
			ammo_pickup.type = AmmoPickup.AmmoType.Machinegun if spawn_type_chance < loot_type_spawn_chance[2] else \
							   AmmoPickup.AmmoType.Shotgun

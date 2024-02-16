class_name WorldGenerator extends Node

var rng = RandomNumberGenerator.new()

var starting_room_length = 50
var room_width = 50
var room_length = 50
var hallway_width = 150
var hallway_length = 20
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

func _init(columns_: int, rows_: int):
	name = "Generate"
	collumns = columns_
	rows = rows_

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
	print("starting room", starting_room_instance.global_position)
	
	starting_hallway_instance = starting_hallway.instantiate()
	add_child(starting_hallway_instance)
	starting_hallway_instance.global_position.z = -(starting_room_length / 2 + hallway_length / 2)
	print("starting hallway", starting_hallway_instance.global_position)
	
	generate_rooms()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_rooms():
	print("num of rooms: ", room_scenes.size())
	
	var big_enemy_room_spawned = false
	var loot_room_spawned = false
	
	var teleport_row = rng.randi_range(0, rows-1)
	var teleport_collumn = rng.randi_range(0, collumns-1)
	
	var special_count = 2
	
	var rows = ResourceStash.game.levelselect * 2
	
	var row_index = 0
	for row in rows:
		var row_rooms: Array[Node3D]
		
		var collumn_index = 0
		for collumn in collumns:
			if row_index == teleport_row and collumn_index == teleport_collumn:
				teleport_room_instance = teleport_room.instantiate()
				row_rooms.append(teleport_room_instance)
				add_child(teleport_room_instance)
				print("room", " type ", "teleport", " row: ", row_index, " collumn: ", collumn_index)
			
			else:
				var rand = rng.randi_range(0, room_scenes.size()-1 + special_count)
				if rand == 0 and big_enemy_room_spawned == false:
					big_enemy_room_instance = big_enemy_room.instantiate()
					row_rooms.append(big_enemy_room_instance)
					add_child(big_enemy_room_instance)
					big_enemy_room_spawned = true
					print("room", " type ", "big_enemy", " row: ", row_index, " collumn: ", collumn_index)
				elif rand == 1 and loot_room_spawned == false:
					loot_room_instance = loot_room.instantiate()
					row_rooms.append(loot_room_instance)
					add_child(loot_room_instance)
					loot_room_spawned = true
					print("room", " type ", "loot_room", " row: ", row_index, " collumn: ", collumn_index)
				else:
					if rand < special_count:
						rand = rng.randi_range(special_count-1, room_scenes.size()-1 + special_count)
					var room_instance = room_scenes[rand - special_count].instantiate()
					row_rooms.append(room_instance)
					add_child(room_instance)
					print("room", " type ", rand, " row: ", row_index, " collumn: ", collumn_index)
			
			collumn_index += 1
			
		var room_index = 0
		for room in row_rooms:
			# hard coded for 3 collumns
			room.global_position = Vector3(room_width * room_index - room_width, 0.0, -(starting_room_length / 2 + hallway_length * (row_index + 1) + room_length * row_index + room_length / 2))
			print("room", " row: ", row_index, " collumn: ", room_index, " ", room.global_position)
			room_index += 1
		
		if row_index == rows - 1:	
			final_hallway_instance = final_hallway.instantiate()
			add_child(final_hallway_instance)
			final_hallway_instance.global_position.z = -(starting_room_length / 2 + hallway_length * (row_index + 1) + room_length * (row_index + 1) + hallway_length / 2)
			print("final hallway ", "row: ", row_index, " ", final_hallway_instance.global_position)
		else:
			var hallway_instance = hallway.instantiate()
			hallway_instances.append(hallway_instance)
			add_child(hallway_instance)
			hallway_instance.global_position.z = -(starting_room_length / 2 + hallway_length * (row_index + 1) + room_length * (row_index + 1) + hallway_length / 2)
			print("hallway ", "row: ", row_index, " ", hallway_instance.global_position)
		
		row_index += 1

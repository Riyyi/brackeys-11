class_name Player extends CharacterBody3D

signal ammo_changed(gun: int, ammo: int)

const SPEED = 7.0
const JUMP_VELOCITY = 7.0

@onready var animation = $Animation
@onready var camera_controller: CameraController = $CameraController
@onready var gun_node: Node3D = $GunViewport/GunCam/GunNode # Node holder for the current gun
@onready var stats_component: StatsComponent = $StatsComponent

# Gun stuff
var machinegun_ammo: int = 50
var shotgun_ammo: int = 2
var gun1: PackedScene # machinegun
var gun2: PackedScene # shotgun
var current_gun: int = 0
var gun_instance: Gun # Scene instantiated

# Door stuff
var door_bash_timer = 0.0
var forced_movement = false
var bash_door_action = false
var target_door: Node3D
var movement_target: Vector3
var rotation_target: float

# Movement
var boost: float = 1.0
var direction: Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func death() -> void:
	animation.play("Death")
	
func _ready():
	tree_exiting.connect(signal_tree_exiting)
	stats_component.no_health.connect(death)

func _process(delta):
	var guncam = $GunViewport/GunCam
	var worldcam = $CameraController/WorldCam
	guncam.global_transform = worldcam.global_transform

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * 2 * delta

	# Handle jump.
	if forced_movement == false:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Get the input direction and handle the movement/deceleration.
		var input_dir = Input.get_vector("WalkLeft", "WalkRight", "WalkUp", "WalkDown")
		var h_rotation = camera_controller.transform.basis.get_euler().y
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, h_rotation).normalized()

		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
	else:
		global_position = global_position.move_toward(movement_target, SPEED * boost * delta)
		camera_controller.global_rotation.y = lerp_angle(camera_controller.global_rotation.y, rotation_target, SPEED * boost * delta)
		camera_controller.global_rotation.x = lerp_angle(camera_controller.global_rotation.x, 0.0, SPEED * boost * delta)
		if global_position.is_equal_approx(movement_target):
			if door_bash_timer > 0.5:
				boost = 2.0
				if bash_door_action == true:
					forced_movement = false
					camera_controller.forced_rotation = false
					bash_door_action = false
					boost = 1.0
					door_bash_timer = 0
				else:
					movement_target = position + Vector3(movement_target.direction_to(Vector3(target_door.global_position.x, global_position.y, target_door.global_position.z))) * 7.5
					bash_door_action = true
			else:
				door_bash_timer += delta

# When player is destructed, store its values in the Game singleton
func signal_tree_exiting() -> void:
	ResourceStash.game.store_player(stats_component.health, machinegun_ammo, shotgun_ammo, gun1, gun2)

func took_damage(hitbox: HitboxComponent) -> void:
	print("HIT: player " + str(hitbox.damage) + " damage")
	stats_component.health -= hitbox.damage

func did_shoot(gun: String):
	if "MachineGun" in gun:
		machinegun_ammo -= 1
		ammo_changed.emit(0, machinegun_ammo)
		if machinegun_ammo == 0:
			gun_instance.has_ammo = false
	if "ShotGun" in gun:
		shotgun_ammo -= 1
		ammo_changed.emit(0, shotgun_ammo)
		if shotgun_ammo == 0:
			gun_instance.has_ammo = false

func _input(event) -> void:
	if event.is_action_pressed("NextWeapon") or event.is_action_pressed("PreviousWeapon"):
		print(current_gun)
		print(gun1)
		print(gun2)
		if current_gun == 0 and gun2 != null:
			switch_gun(1)
		elif current_gun == 1 and gun1 != null:
			switch_gun(0)
	elif event.is_action_pressed("Weapon1"):
		if gun1 != null:
			switch_gun(0)
	elif event.is_action_pressed("Weapon2"):
		if gun2 != null:
			switch_gun(1)

func switch_gun(gunid):
	# Cleanup old gun
	if(gun_node.get_child_count() != 0):
		gun_node.remove_child(gun_instance)
	
	# Set new gun
	if gunid == 0:
		current_gun = 0
		gun_instance = gun1.instantiate() # machinegun
		gun_instance.has_ammo = machinegun_ammo > 0
	else:
		gun_instance = gun2.instantiate() # shotgun
		current_gun = 1
		gun_instance.has_ammo = shotgun_ammo > 0
	gun_instance.did_shoot.connect(did_shoot)
	gun_node.add_child(gun_instance)
	
func weapon_pickup(weapon: PackedScene):
	if gun1 == null:
		gun1 = weapon
		switch_gun(0)
	elif gun2 == null:
		gun2 = weapon
	elif current_gun == 0:
		gun1 = weapon
		switch_gun(0)
	else:
		gun2 = weapon
		switch_gun(1)

func bash_door(start_position, direction, door):
	forced_movement = true
	camera_controller.forced_rotation = true
	movement_target = start_position
	rotation_target = direction
	target_door = door

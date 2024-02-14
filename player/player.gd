class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera_controller = $CameraController
@onready var gun_node = $GunViewport/GunCam/GunNode

var gun_instance: Node

var Gun: PackedScene:
	get:
		return Gun
	set(gun):
		Gun = gun
		if(gun_node.get_child_count() == 0):
			gun_instance = Gun.instantiate()
			gun_node.add_child(gun_instance)
		print(gun_node.get_children())

var direction: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	var guncam = $GunViewport/GunCam
	var worldcam = $CameraController/WorldCam
	guncam.global_transform = worldcam.global_transform

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
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
	
func pickup(item):
	Gun = item

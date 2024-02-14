extends Node3D

@export var Bullet: PackedScene

# Called when the node enters the scene tree for the first time.

func shoot():
	$BulletEmitter.add_child(Bullet.instantiate())
	#GunMesh.BulletEmitter.add_child(Bullet.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("LeftClick"):
		shoot()

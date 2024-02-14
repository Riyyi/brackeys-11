extends Node3D

@export var Bullet: PackedScene

# Called when the node enters the scene tree for the first time.

@export var firerate = 10.0

var firerate_timer = 0.0

func shoot():
	$BulletEmitter.add_child(Bullet.instantiate())
	$AudioStreamPlayer.play()
	#GunMesh.BulletEmitter.add_child(Bullet.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if firerate_timer > (1.0 / firerate):
		if Input.is_action_pressed("LeftClick"):
			shoot()
			firerate_timer = 0.0
	firerate_timer += delta

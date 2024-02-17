class_name Bullet extends Node3D

@export var ProjectileSpeed : float = 1.0

@onready var hitbox_component: HitboxComponent = %HitboxComponent # acces in the child via unique name
@onready var ray: RayCast3D = $RayCast3D

var counter = 0.0
@export var lifetime : int = 10 

func _ready() -> void:
	hitbox_component.hit.connect(queue_free.unbind(1)) # Drop arguments from 1 to 0

func _process(delta) -> void:
	if counter > lifetime:
		queue_free()
	counter += delta;

func _physics_process(delta):
	var movement = Vector3(0, 0, ProjectileSpeed) * delta * 10
	translate(movement)
	ray.target_position = -movement
	if ray.is_colliding():
		hitbox_component.body_hit(ray.get_collider())

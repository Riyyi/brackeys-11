class_name Bullet extends Node3D

@onready var hitbox_component: HitboxComponent = %HitboxComponent # acces in the child via unique name

func _ready() -> void:
	hitbox_component.hit.connect(queue_free.unbind(1)) # Drop arguments from 1 to 0

func _process(_delta) -> void:
	pass

func _physics_process(delta):
	translate(Vector3(0, 0, 1) * delta * 10)

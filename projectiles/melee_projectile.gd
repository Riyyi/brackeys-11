class_name MeleeProjectile extends Bullet

var attack_despawn: float = 0.75

func _physics_process(delta) -> void:
	attack_despawn -= delta
	if attack_despawn < 0:
		queue_free()

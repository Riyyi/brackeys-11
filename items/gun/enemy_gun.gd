class_name EnemyGun extends Gun

# Is the enemy trying to shoot?
var holding_trigger: bool = false

func _process(delta) -> void:
	if firerate_timer > (1.0 / firerate):
		if holding_trigger:
			print("ENEMY IS SHOOTING")
			shoot()
			firerate_timer = 0.0
	firerate_timer += delta

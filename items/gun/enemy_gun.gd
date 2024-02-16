class_name EnemyGun extends Gun

@export var spawn_delay: float = 0.0

# Is the enemy trying to shoot?
var holding_trigger: bool = false

func shoot() -> void:
	did_shoot.emit(name)
	await get_tree().create_timer(spawn_delay).timeout
	bullet_emitter.add_child(bullet.instantiate())
	bangbang.play()

func _process(delta) -> void:
	if firerate_timer > (1.0 / firerate):
		if holding_trigger:
			shoot()
			firerate_timer = 0.0
			holding_trigger = false
	firerate_timer += delta

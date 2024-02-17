class_name EnemyDeathState extends State

var enemy: Enemy
var has_death: bool = false

func _ready() -> void:
	enemy = persistent_state
	 
	var list: PackedStringArray = animation.get_animation_list()
	var has_dying: bool = list.has("Dying")
	has_death = list.has("Death")
	
	if not has_dying and not has_death:
		enemy.queue_free()
	
	if has_dying:
		enemy.dying = true
		enemy.set_collision_mask_value(1, true) # enable collision with the environment
		await get_tree().create_timer(0.1).timeout
		animation.play("Dying")
		animation.animation_finished.connect(become_death)
		return
		
	death()

func _process(delta) -> void:
	# Stop moving, not on Y because gravity is enabled in this state
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, 1.0)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0.0, 1.0)

func become_death(name: String) -> void:
	animation.animation_finished.disconnect(become_death)
	death()

func death() -> void:
	if has_death:
		enemy.dead = true
		enemy.collision_shape_3d.queue_free()
		animation.play("Death")
	else:
		enemy.queue_free()

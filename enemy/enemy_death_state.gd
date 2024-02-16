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
		enemy.dead = true
		enemy.set_collision_mask_value(1, true) # enable collision with the environment
		await get_tree().create_timer(0.1).timeout
		animation.play("Dying")
		animation.animation_finished.connect(become_death)
		return
		
	death()

func become_death(name: String) -> void:
	death()

func death() -> void:
	if has_death:
		animation.play("Death")
	else:
		enemy.queue_free()

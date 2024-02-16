class_name MeleeEnemy extends Enemy

func _ready() -> void:
	super()
	nav_agent.avoidance_priority = rng.randf_range(0.0, 0.5)

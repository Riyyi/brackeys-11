class_name BasicEnemy extends Enemy

func _ready() -> void:
	super()
	nav_agent.avoidance_priority = rng.randf_range(0.5, 1.0)

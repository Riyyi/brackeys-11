class_name BasicEnemy extends Enemy

@onready var nav_agent: NavigationAgent3D = $NavAgent

func _ready() -> void:
	super()
	
	state_factory = StateFactory.new([BasicEnemyWalkState])
	change_state(0)

class_name StatsComponent extends Node

# Create the health variable and connect a setter
@export var health: int = 1:
	set(value):
		health = value
		
		# Hit
		health_changed.emit()
		
		# Death
		if health < 0:
			health = 0
			no_health.emit()

signal health_changed()
signal no_health()

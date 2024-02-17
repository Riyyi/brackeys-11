class_name HitboxComponent extends Area3D

@export var damage: int = 1

signal hit(body: Node3D)

func _ready():
	body_entered.connect(on_body_entered)
		
func body_hit(body: Node3D):
	# Signal that hitbox hit something
	hit.emit(body)

	# Inform hurtbox it was hit
	if "Player" in body.name:
		var player = body as Player
		player.took_damage(self)
		return
	if "Enemy" in body.name:
		var enemy = body as Enemy
		enemy.took_damage(self)
		return

func on_body_entered(body: Node3D):
	body_hit(body)

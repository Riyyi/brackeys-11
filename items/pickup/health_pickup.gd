class_name HealthPickup extends Pickup

@export var amount: int = 20

func give_player_item(player: Player):
	player.stats_component.health = min(player.stats_component.health + amount, 125)

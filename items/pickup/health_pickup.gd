class_name HealthPickup extends Pickup

@export var amount: int = 5

func give_player_item(player: Player):
	player.stats_component.health += amount

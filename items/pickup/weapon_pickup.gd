class_name WeaponPickup extends Pickup

@export var item: PackedScene

func give_player_item(player: Player):
	assert(item != null, "Forgot to set weapon")
	player.weapon_pickup(item)

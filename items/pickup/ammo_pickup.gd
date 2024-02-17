class_name AmmoPickup extends Pickup

@export var amount: int = 5
@export var type: AmmoType

enum AmmoType { Machinegun = 0, Shotgun = 1 }

func give_player_item(player: Player):
	if (type == AmmoType.Machinegun):
		player.machinegun_ammo += amount
		player.ammo_changed.emit(0, player.machinegun_ammo)
	else:
		player.shotgun_ammo += amount
		player.ammo_changed.emit(1, player.shotgun_ammo)

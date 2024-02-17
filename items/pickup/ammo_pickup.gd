class_name AmmoPickup extends Pickup

@export var machinegun_amount: int = 60
@export var shotgun_amount: int = 5
@export var type: AmmoType
enum AmmoType { Machinegun = 0, Shotgun = 1 }

func give_player_item(player: Player):
	if (type == AmmoType.Machinegun):
		player.machinegun_ammo += min(machinegun_amount, 200)
		player.ammo_changed.emit(0, player.machinegun_ammo)
	else:
		player.shotgun_ammo += min(shotgun_amount, 20)
		player.ammo_changed.emit(1, player.shotgun_ammo)

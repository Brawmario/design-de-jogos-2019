extends Area2D

func interact(other):
	var player = other
	if player.is_in_group("Player"):
		if player.inventory:
			return ItemEnums.Switch
		return ItemEnums.Pickup
	pass
extends Area2D

func interact(other):
	var player = Player
	if Player is other:
		if player.inventory:
			return ItemEnums.Switch
		return ItemEnums.Pickup
	pass
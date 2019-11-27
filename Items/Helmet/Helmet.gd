extends Area2D

func interact(other):
	var player = other
	if player.is_in_group("Player"):
		return ItemEnums.Wear
	pass
extends Area2D
class_name Matchstick

onready var sprite = $Sprite

func interact(other):
	var player := other as Player
	if player:
		if player.inventory:
			return ItemEnums.Switch
		return ItemEnums.Pickup
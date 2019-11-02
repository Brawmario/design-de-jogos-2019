extends Area2D
class_name Hole

func interact(other):
	var player := other as Player
	if player:
		var leaves: Leaves = player.inventory
		if leaves:
			leaves.monitorable = false
			leaves.position = Vector2()
			add_child(leaves)
			player.inventory = null
			return ItemEnums.Drop
	pass
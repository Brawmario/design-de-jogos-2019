extends Area2D
class_name Hole

var leaves_ref = null

func interact(other):
	var player := other as Player
	if player:
		var leaves: Leaves = player.inventory as Leaves
		if leaves:
			leaves.monitorable = false
			leaves.position = Vector2()
			add_child(leaves)
			leaves_ref = leaves
			player.inventory = null
			return ItemEnums.Drop
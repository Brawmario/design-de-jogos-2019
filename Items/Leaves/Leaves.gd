extends Area2D
class_name Leaves

onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact(other):
	var player := other as Player
	if player:
		return ItemEnums.Pickup
	pass
extends Area2D
class_name Banana

onready var sprite = $Sprite
onready var is_banana = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact(other):
	var player = other
	if player.is_in_group("Player"):
		if player.inventory:
			return ItemEnums.Switch
		return ItemEnums.Pickup
	pass
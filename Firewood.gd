extends Area2D
class_name Firewood
var is_burning = false 

onready var sprite = $SpriteWood

func _ready():
	$SpriteFire.visible = false 
	pass # Replace with function body.

func interact(other):
	var player := other as Player
	if player:
		var matchstick: Matchstick = player.inventory as Matchstick
		if matchstick:
			$SpriteWood.visible = false
			$SpriteFire.visible = true 
			
			is_burning = true 
			matchstick.monitorable = false
			
			player.inventory = null
			return ItemEnums.Drop

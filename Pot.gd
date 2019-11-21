extends Area2D
class_name Pot

var GROWING_TIME = 5
onready var sprite = $SpritePot
var timer 
var timer2
var timer3
var grown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpritePot.visible = true
	$SpritePlanted.visible = false
	$SpriteTree.visible = false
	$SpriteTreeBanana.visible = false
	
	timer = Timer.new() 
	timer2 = Timer.new()
	timer3 = Timer.new()
	timer.set_one_shot(true)
	timer2.set_one_shot(true)
	timer3.set_one_shot(true)
	timer.set_wait_time(GROWING_TIME)
	timer2.set_wait_time(GROWING_TIME)
	timer3.set_wait_time(GROWING_TIME)
	
	timer.connect("timeout", self, "growing_sprout")
	timer2.connect("timeout", self, "growing_tree")
	timer3.connect("timeout", self, "growing_banana")
	
	add_child(timer)
	add_child(timer2)
	add_child(timer3)
	
	
	
	pass # Replace with function body.


func interact(other):
	var player := other as Player
	if player:
		var _seed: Seed = player.inventory as Seed
		
		if _seed:
			_seed.monitorable = false
			$SpritePot.visible = false 
			$SpritePlanted.visible = true
			player.inventory = null
			
			print("We have planted")
			timer.start()
			
			return ItemEnums.Drop
			

	
func growing_sprout(): 
	print("We are growing?")  
	$SpritePlanted.visible = false
	$SpriteSprout.visible = true

	timer2.start()

	

func growing_tree(): 
	print("We are growing more!!")
	$SpriteSprout.visible = false
	$SpriteTree.visible = true

	timer3.start()
	

func growing_banana(): 
	print("We have grown")
	$SpriteTree.visible = false
	$SpriteTreeBanana.visible = true
	grown = true
	



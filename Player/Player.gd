extends KinematicBody2D
class_name Player

var vel: float = 500.0
var item = null
var interact_cooldown = false

onready var interact_timeout = $InteractTimeout
onready var inventory = null
onready var movable = true
onready var last_direction

signal inventory_update(item)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta: float):
	var velocity = Vector2()  # The player's movement vector.
	if(movable):
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
			last_direction = "r"
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
			last_direction = "l"
		if Input.is_action_pressed("ui_down"):
				velocity.y += 1
				last_direction = "d"
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
			last_direction = "u"
		velocity = velocity.normalized() * vel
		move_and_slide(velocity)

	# Interact
	if Input.is_action_just_pressed("interact"):
		if inventory is Banana:
			var banana_peel = load("res://Items/BananaPeel/BananaPeel.tscn").instance()
			banana_peel.position = self.position
			self.get_parent().add_child(banana_peel)
			self.inventory = null
			emit_signal("inventory_update", null)
		elif inventory is BananaPeel:
			self.inventory.position = self.position
			self.get_parent().add_child(self.inventory)
			self.inventory = null
			emit_signal("inventory_update", null)
			
		if inventory is Sword:
			if(movable):
				var sword = load("res://Items/Sword/Sword.tscn").instance()
				sword.position = self.position
				self.get_parent().add_child(sword)
				sword.attack() 
				sword.connect("finished_attack", self, "_on_Sword_finished_attack")
			movable = false
		
		if item and item.has_method("interact"):
			var item_ref = item
			var interact_result = item_ref.interact(self)
			match interact_result:
				ItemEnums.Pickup:
					item_ref.get_parent().remove_child(item_ref)
					inventory = item_ref
					emit_signal("inventory_update", item_ref)
					print("Picked up Item")
				ItemEnums.Switch:
					self.inventory.position = self.position
					self.get_parent().add_child(self.inventory)
					item_ref.get_parent().remove_child(item_ref)
					inventory = item_ref
					emit_signal("inventory_update", item_ref)
					print("Switched items")
				ItemEnums.Drop:
					emit_signal("inventory_update", null)
					print("Dropped Item")


func _on_InteractionArea_area_entered(area):
	if area.is_in_group("Items"):
		print("Item in Range")
		item = area


func _on_InteractionArea_area_exited(area):
	if area.is_in_group("Items"):
		print("Item left Range")
		item = null
		



func _on_Sword_finished_attack():
	print("in signal")
	movable = true

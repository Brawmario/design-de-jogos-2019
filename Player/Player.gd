extends KinematicBody2D
class_name Player

var vel: float = 500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta: float):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1 
	velocity = velocity.normalized() * vel
	move_and_slide(velocity)


func _on_InteractionArea_area_entered(area):
	if area.is_in_group("Items"):
		print("Item in Range")

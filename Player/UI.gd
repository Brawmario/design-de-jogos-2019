extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var npr: NinePatchRect = $NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_inventory_update(item):
	for child in npr.get_children():
		child.queue_free()
	if not item:
		return
	var icon: Sprite = item.sprite.duplicate()
	icon.position += Vector2(50, 50)
	npr.add_child(icon)

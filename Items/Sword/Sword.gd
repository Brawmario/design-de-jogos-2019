extends Area2D
class_name Sword

# warning-ignore:unused_class_variable
onready var sprite = $Sprite
enum STATES {IDLE, ATTACK, HIT}
var current_state = STATES.IDLE 
signal finished_attack
signal hit_boss

func _ready():
	set_physics_process(false)
	pass 


func set_state(new_state): 
	current_state = new_state
	match current_state: 
		STATES.IDLE: 
			set_physics_process(false) 
			self.queue_free()
		STATES.ATTACK: 
			set_physics_process(true) 
			$AnimationPlayer.play("Attack")


func interact(other):
	var player = other
	if player.is_in_group("Player"):
		if player.inventory:
			return ItemEnums.Switch
		return ItemEnums.Pickup


# warning-ignore:unused_argument
func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if not overlapping_bodies: 
		return
		

func attack(): 
	print("Attack")
	set_state(STATES.ATTACK)



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		emit_signal("finished_attack")
		set_state(STATES.IDLE)
		print("animation finished")

func _on_Sword_body_entered(body):
	if body.is_in_group("Boss"):  
		print("hit boss")
		emit_signal("hit_boss")

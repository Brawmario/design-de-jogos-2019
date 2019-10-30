extends KinematicBody2D
class_name Boss

var vel := 400.0 * 60 
var follow_player := false
var player_ref: Player

func _physics_process(delta):
	if follow_player:
		follow(delta)

func follow(delta: float):
	var dir := (player_ref.global_position - self.global_position).normalized()
	# print(dir)
	move_and_slide(dir * vel * delta)
	
func _on_Area2D_body_entered(body):
	var player := body as Player
	if not player:
		return
	print("Boss started following")
	player_ref = player
	follow_player = true

func _on_Area2D_body_exited(body):
	var player := body as Player
	if not player:
		return
	print("Boss stopped following")
	follow_player = false
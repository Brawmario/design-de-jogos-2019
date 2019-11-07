extends KinematicBody2D
class_name Boss

var vel := 300.0 * 60 
var follow_player := false
var player_ref: Player
var attack_player := false
var boss_trapped := false

# Wait time for the trapped boos
var time := Timer.new()

func _physics_process(delta):
	
	if follow_player:
		follow(delta)
	#else: (TODO RANDOM MOVEMENT)!
		#var move_idle := Vector2(rand_range(0,1), rand_range(0,1)).normalized()
		#print(move_idle)
		#move_and_slide(move_idle * vel * delta)
	if attack_player:
		$Hammer/bossAttack_1.play("bossAttack_1")

func follow(delta: float):
	var dir := (player_ref.global_position - self.global_position).normalized()
	# print(dir)
	if boss_trapped == false:
		move_and_slide(dir * vel * delta)
		look_at(player_ref.global_position)
	#rotation = tan(dir.x/dir.y)
	#rotate(tan(dir.x/dir.y))
	
func _on_Area2D_body_entered(body):
	print(body)
	var player := body as Player
	if not player:
		return
	player_ref = player
	follow_player = true

func _on_Area2D_body_exited(body):
	var player := body as Player
	if not player:
		return
	follow_player = false

func _on_attackArea_body_entered(body): 
	var player := body as Player
	if not player:
		return
	follow_player = true
	attack_player = true

func _on_attackArea_body_exited(body):
	var player := body as Player
	if not player:
		return
	attack_player = false


func _on_attackArea_area_shape_entered(area_id, area, area_shape, self_shape):
	var hole := area as Hole
	if not hole:
		return 
	# Boss percive the hole
	boss_trapped = true
	self.add_child(time)
	time.start()
	yield(time, 'timeout')
	#$lowerArmorAnimation.play("lowerArmorAnimation")
	boss_trapped = false
	

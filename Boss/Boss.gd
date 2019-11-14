extends KinematicBody2D
class_name Boss

var vel_chasing := 300.0 * 60 
var vel_idle := 100 * 60
var random_Waypoint:=Vector2(rand_range(0,2000), rand_range(0,2000))
var player_ref: Player
var attack_player := false
var state:=BossState.StandStill
var animation

# Wait time for the trapped boos
var time := Timer.new()

func _physics_process(delta):
	
	match state:
			BossState.Trapped:
				return
			BossState.StandStill:
				return
			BossState.MoveRandom:
				if(random_Waypoint==null || self.global_position.distance_to(random_Waypoint)<10):
					random_Waypoint=Vector2(rand_range(0,2000), rand_range(0,2000))
				var dir := (random_Waypoint - self.global_position).normalized()
				move_and_slide(dir * vel_idle * delta)
				look_at(random_Waypoint)
			BossState.FollowPlayer:
				follow(delta)			
	if attack_player:
		$Hammer/bossAttack_1.play("bossAttack_1")

func follow(delta: float):
	var dir := (player_ref.global_position - self.global_position).normalized()
	move_and_slide(dir * vel_chasing * delta)
	look_at(player_ref.global_position)
	
func _on_Area2D_body_entered(body):
	var player := body as Player
	if not player:
		return
	player_ref = player
	state=BossState.FollowPlayer

func _on_Area2D_body_exited(body):
	var player := body as Player
	if not player:
		return
	state=BossState.MoveRandom

func _on_attackArea_body_entered(body): 
	var player := body as Player
	if not player:
		return
	player_ref = player
	state=BossState.FollowPlayer
	attack_player = true

func _on_attackArea_body_exited(body):
	var player := body as Player
	if not player:
		return
	attack_player = false

func moveAgain():
	print("called")
	state=BossState.MoveRandom
	
func _on_attackArea_area_shape_entered(area_id, area, area_shape, self_shape):
	var hole := area as Hole
	if hole:
		if hole.leaves_ref:
			state=BossState.StandStill
			self.global_position = area.global_position
			hole.leaves_ref.queue_free()
			hole.leaves_ref=null
			$lowerArmorAnimation.play("lowerArmorAnimation")
			yield( $lowerArmorAnimation, "animation_finished" )
			state=BossState.MoveRandom
			return
		else:
			state=BossState.MoveRandom
	var banana := area as BananaPeel
	if banana:
		state=BossState.StandStill
		banana.queue_free()
		$upperArmorAnimation.play("upperArmorDestroy")
		yield( $upperArmorAnimation, "animation_finished" )
		state=BossState.MoveRandom

extends KinematicBody2D
class_name Boss

var vel_runAway= 50*60
var vel_chasing := 300.0 * 60 
var vel_idle := 100 * 60
var random_Waypoint:=Vector2(rand_range(0,2000), rand_range(0,2000))
var player_ref: Player
var attack_player := false
var state:=BossState.StandStill
var animation
var fell_heat = true

signal player_hit

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
			BossState.RunAway:
				runAway(delta)
	if attack_player:
		$Hammer/bossAttack_1.play("bossAttack_1")

func runAway(delta: float):
	var dir := -1*(player_ref.global_position - self.global_position).normalized()
	move_and_slide(dir * vel_runAway* delta)
	look_at(player_ref.global_position)
	
func follow(delta: float):
	var dir := (player_ref.global_position - self.global_position).normalized()
	move_and_slide(dir * vel_chasing * delta)
	look_at(player_ref.global_position)
	
func _on_Area2D_body_entered(body):
	var player := body as Player
	if not player:
		return
	if has_node("Hammer"):
		player_ref = player
		state=BossState.FollowPlayer
	else:
		state=BossState.RunAway

func _on_Area2D_body_exited(body):
	var player := body as Player
	if not player:
		return
	state=BossState.MoveRandom

func _on_attackArea_body_entered(body): 
	var player := body as Player
	if not player:
		return
	if(state==BossState.FollowPlayer):
		player_ref = player
		attack_player = true

func _on_attackArea_body_exited(body):
	var player := body as Player
	if not player:
		return
	attack_player = false

func moveAgain():
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
			var dir := ( self.global_position- hole.global_position)
			random_Waypoint= self.global_position + dir
			state=BossState.MoveRandom
	var banana := area as BananaPeel
	if banana:
		state=BossState.StandStill
		banana.queue_free()
		$upperArmorAnimation.play("upperArmorDestroy")
		$rotatingAfterBanana.play("rotating")
		yield( $upperArmorAnimation, "animation_finished" )
		yield( $rotatingAfterBanana, "animation_finished" )
		state=BossState.MoveRandom
	var campfire := area as Firewood
	if campfire && campfire.is_burning:
		if fell_heat:
			fell_heat = false
			state = BossState.StandStill
			$helmetAnimation.play("loseHelmet")
			var helmet = load("res://Items/Helmet/Helmet.tscn").instance() 
			helmet.add_to_group("Items")
			helmet.position = self.position
			self.get_parent().add_child(helmet)
			yield( $helmetAnimation, "animation_finished")
			state = BossState.MoveRandom
			



func _on_Hammer_area_entered(area):
	var pot := area as Pot 
	if area.is_in_group("Tree") && pot.grown:
		var banana = load("res://Items/Banana/Banana.tscn").instance() 
		banana.add_to_group("Items")
		banana.position = self.position
		self.get_parent().add_child(banana)
		pot.grown = false 


func _on_Hammer_body_entered(body):
	var player := body as Player
	if player: 
		if player.armor:
			print('Player has armor')
			state = BossState.StandStill
			$Hammer/looseHammer.play("looseHammer")
			attack_player=false
			state = BossState.RunAway
			yield( $Hammer/looseHammer, "animation_finished")
			if has_node("Hammer"):
				remove_child(get_node("Hammer"))
			return
		emit_signal("player_hit")
		print("player hit")

extends KinematicBody2D
class_name Boss

var vel_chasing := 300.0 * 60 
var vel_idle := 100 * 60
var follow_player := false
var random_Waypoint:=Vector2(rand_range(0,2000), rand_range(0,2000))
var player_ref: Player
var attack_player := false
var boss_trapped := false
var boss_can_fall := true
var boss_can_slide := true
var boss_fell_heat := true
var boss_heath : int = 5

# Wait time for the trapped boos
var time := Timer.new()

func _physics_process(delta):
	if boss_trapped:
		return
	if follow_player:
		follow(delta)
	else:
		if(random_Waypoint==null || self.global_position.distance_to(random_Waypoint)<10):
			random_Waypoint=Vector2(rand_range(0,2000), rand_range(0,2000))
		var dir := (random_Waypoint - self.global_position).normalized()
		move_and_slide(dir * vel_idle * delta)
		look_at(random_Waypoint)
	if attack_player:
		$Hammer/bossAttack_1.play("bossAttack_1")

func follow(delta: float):
	var dir := (player_ref.global_position - self.global_position).normalized()
	if not boss_trapped:
		move_and_slide(dir * vel_chasing * delta)
		look_at(player_ref.global_position)
	
func _on_Area2D_body_entered(body):
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
	player_ref = player
	follow_player = true
	attack_player = true

func _on_attackArea_body_exited(body):
	var player := body as Player
	if not player:
		return
	attack_player = false


func _on_attackArea_area_shape_entered(area_id, area, area_shape, self_shape):
	var hole := area as Hole
	if not hole || hole.leaves_ref==null:
		var banana := area as BananaPeel
		if not banana:
			var campfire := area as CampFire
			if not campfire:
				return
			bossDropHelmet()
			boss_fell_heat = false
			return
		print('escorregou na banana')
		slideBananaBoss(area)
		boss_can_slide = false
		return		
	trappBossHole(area)
	boss_can_fall = false
	# Boss percive the hole

	
func trappBossHole(area):
	if boss_can_fall:
		boss_heath -= 1
		boss_trapped = true
		self.global_position=area.global_position
		self.add_child(time)
		time.start()
		$lowerArmorAnimation.play("lowerArmorAnimation")
		yield(time, 'timeout')
		boss_trapped = false

func slideBananaBoss (area):
	if boss_can_slide:
		boss_heath -= 1
		$rotatingAfterBanana.play("rotating")
		$upperArmorAnimation.play("upperArmorDestroy")
		var dir := (player_ref.global_position - self.global_position).normalized()
		move_and_slide(dir * vel_chasing / 10)
	
func bossDropHelmet():
	if boss_fell_heat:
		boss_heath -= 1
		boss_trapped = true
		self.add_child(time)
		time.wait_time = 3
		time.start()
		$Helmet/helmetAnimation.play('helmetMovement')
		yield(time, 'timeout')
		boss_trapped = false

extends CharacterBody3D


var sprinting = false
var ticks = 0

var SPEED = 5.0
@export var JUMP_VELOCITY = 8.5
var camera_sense = 0.002
var camera_sense_multiplier = 1.0
@onready var Hand = $Camera3D/Hand
var hoe = preload("res://Tools/Hoe.tscn")
var seeds = preload("res://Tools/bag_of_seeds.tscn")
var scythe = preload("res://Tools/scythe.tscn")
var watering_can = preload("res://Tools/watering_can.tscn")
var shovel = preload("res://Tools/shovel.tscn")
var mine_placer = preload("res://Tools/mine_placer.tscn")
var pause_movement = false
var seed_bag_save = 0
var plantcount : int = 0
var isunlocked: Dictionary = {"1":true,"2":true,"3":true,"4":true,"5":true, "6": true}
var isShop : bool = false
var health : int = 2
var current_item : int = 1
var is_ragdoll: bool = false
var ragdoll_opos: Vector3 = Vector3(0,0,0)
var handhidden : bool = false
var jumping : bool = false
var quotaSecond : bool = false
var addedQuota : float = 0
var quotaCheck : bool = true
var addCheck : bool = false
var plsCheck : bool = true
var canFarm: bool = false
var knockbackX : float = 0.0
var knockbackY : float = 0.0
var isPPactive : bool = false
var shaderCheck : bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 20.0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority():
		return
	$Camera3D.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var hud = load("res://Player/hud.tscn").instantiate()
	add_child(hud)
	request_mp_spawned.rpc()
	request_hand_hide.rpc()
	
@rpc("call_local","any_peer","unreliable")
func request_hand_hide():
	hand_hide.rpc(current_item)
	
@rpc("call_remote","authority","reliable")
func request_mp_spawned():
	var mps = {}
	var zones = get_node("/root/World/zones").get_children()
	var mpst = []
	for z in zones:
		if z.property_owner:
			mpst.append(z.property_owner.name.split("_")[-1])
		else:
			mpst.append(null)
	mps["zones"] = mpst
	mpst = []
	for i in Global.players:
		mpst.append(i.name.split("_")[-1])
	mps["players"] = mpst
	#var mps = []
	#for node in get_node("/root/World/TilledLand").get_children():
		#var sgs = {"has_plant":null}
		#sgs["position"] = node.position
		#sgs["name"] = node.name
		#var ip = node.get_node_or_null("PLANT")
		#if ip:
			#sgs["has_plant"] = true
			#sgs["plant_settings"] = ip.quick_settings
			#sgs["plant_anim_pos"] = ip.get_node("Plant/PlantBody/AnimationPlayer").current_animation_position
			#sgs["plant_is_growing"] = ip.get_node("Plant/PlantBody/AnimationPlayer").is_playing()
		#mps.append(sgs)
	request_mp_spawned_callback.rpc_id(multiplayer.get_remote_sender_id(),mps)
@rpc("any_peer", "call_local")
func recieve_damage(amt):
	if $IFrameTimer.is_stopped() and $RagdollTimer.is_stopped():
		var childss
		health -= amt
		childss = get_node_or_null("HUD/HealthBar")
		if childss: childss.value -= amt
		if $RagdollTimer.is_stopped():
			if health <= 0:
				health = 2
				if childss: childss.value = 2
				death()
		
@rpc("call_remote","any_peer","reliable")
func request_mp_spawned_callback(mps):
	var j = -1
	for i in mps["zones"]:
		j += 1
		if !i: continue
		get_node("/root/World/zones").get_children()[j].property_owner = get_node("/root/World/mpSpawned_" + i)
	for i in mps["players"]:
		Global.players.append(get_node("/root/World/mpSpawned_" + i))
	#var tillI = load("res://Farming/tilled_land.tscn")
	#for sgs in mps:
		#var till = tillI.instantiate()
		#till.position = sgs.position
		#till.name = sgs.name
		#if sgs.has_plant:
			#var plant = get_node("/root/World/PlantSpawner").quick_init(sgs.plant_settings.plant_id)
			#plant.name = "PLANT"
			#plant.get_node("Plant/PlantBody/AnimationPlayer").seek(sgs.plant_anim_pos)
			#if sgs.plant_is_growing:
				#plant.start_grow()
			#till.add_child(plant)
		#get_node("/root/World/TilledLand").add_child(till)
	
func _input(event):
	if not is_multiplayer_authority(): 
		return
	if pause_movement: return
	var ncams = camera_sense * camera_sense_multiplier
	if $RagdollTimer.is_stopped():
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * ncams)
			$Camera3D.rotate_x(-event.relative.y * ncams)
			$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)

func change_sensitivity(sense):
	camera_sense_multiplier = sense/50.0 + .03
	
@rpc("call_remote","authority","unreliable")
func hand_hide(item):
	if $Camera3D/Hand.visible:
		$Camera3D/Hand.hide()
	if not $"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".visible:
		$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".show()
	if not $"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".get_children()[item-1].visible:
		$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".get_children()[item-1].show()
	for x in $"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".get_children():
		if x != $"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".get_children()[item-1]:
			if x.visible:
				x.hide()
	


@rpc("call_remote")
func hoe_animation_remote():
	pass

@rpc("call_remote")
func seed_bag_animation_remote():
	pass

@rpc("call_remote")
func scythe_animation_remote():
	pass

@rpc("call_remote")
func watering_can_animation_remote():
	pass

@rpc("call_remote")
func shovel_animation_remote():
	pass

@rpc("call_remote")
func land_mine_animation():
	pass
	
@rpc("call_remote")
func vaccum_gun_animation():
	pass

@rpc("call_local","any_peer","reliable")
func switch_hand(id):
	if id == 1:
		Hand.get_child(0).queue_free()
		var nscn = hoe.instantiate()
		nscn.name = "Hoe"
		Hand.add_child(nscn)
	if id == 2:
		Hand.get_child(0).queue_free()
		var nscn = seeds.instantiate()
		nscn.name = "BagOfSeeds"
		Hand.add_child(nscn)
		nscn.plant = seed_bag_save
	if id == 3:
		Hand.get_child(0).queue_free()
		var nscn = scythe.instantiate()
		nscn.name = "Scythe"
		Hand.add_child(nscn)
		nscn.init_pos()
	if id == 4:
		Hand.get_child(0).queue_free()
		var nscn = watering_can.instantiate()
		nscn.name = "WateringCan"
		Hand.add_child(nscn)
	if id == 5:
		Hand.get_child(0).queue_free()
		var nscn = shovel.instantiate()
		nscn.name = "Shovel"
		Hand.add_child(nscn)
	if id == 6:
		Hand.get_child(0).queue_free()
		var nscn = mine_placer.instantiate()
		nscn.name = "MinePlacer"
		Hand.add_child(nscn)
	hand_hide.rpc(current_item)

func _physics_process(delta):
	#i fucking give up
	#$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".position=Vector3(-0.087,0.387,-0.137)-$"Node3D/Armature/Skeleton3D".get_bone_pose_position(8)
	#$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/Hand2".rotation = Vector3(-0.3927,0.733,-0.0541)-$"Node3D/Armature/Skeleton3D".get_bone_pose_rotation(8).get_euler()
	if get_node("Camera3D/Hand").get_child(0).name == "BagOfSeeds":
		seed_bag_save = get_node("Camera3D/Hand/BagOfSeeds").plant
	if is_ragdoll:
		$"Node3D/Armature/Skeleton3D/Physical Bone Body".global_position = $Node3D.global_position
		$"Node3D/Armature/Skeleton3D/Physical Bone Body/Camera3D".look_at(ragdoll_opos)
	if !multiplayer.multiplayer_peer || !is_multiplayer_authority(): return
	ticks += 1
	if $RagdollTimer.is_stopped():
		stopragdoll.rpc()
	var zones = get_node("/root/World/zones").get_children()
	for i in zones:
		if $Hitbox.overlaps_area(i):
			if i.property_owner != self:
				canFarm = false
			else:
				canFarm = i.farmable

	if Input.is_action_just_pressed("menu"):
		if get_node_or_null("ShopMenu"):
			get_node("ShopMenu").queue_free()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			pause_movement = false
		elif !get_node_or_null("Menu"):
			$Node3D/AnimationPlayer.stop()
			if not is_on_floor():
				$Node3D/AnimationPlayer2.stop()
				idle_animation.rpc()
			var mnu = load("res://Menus/menu.tscn").instantiate()
			mnu.name = "Menu"
			add_child(mnu)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pause_movement = true
		else:
			get_node("Menu").queue_free()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			pause_movement = false
	
	var tooltip = $Camera3D/ToolTip.get_collider()
	if tooltip:
		if tooltip.name == "PlantBox":
			get_node("HUD/ToolTip").text = (
			["Wheat","Corn","Potato","Carrot","Mushroom"][tooltip.get_parent().plant_id] + 
			", " + 
			str(int(tooltip.get_parent().get_node("Plant/PlantBody/AnimationPlayer").current_animation_position*100)) + 
			"% Grown, " + str(int(tooltip.get_parent().get_parent().water_level*100)) + "% Watered"
			)
		if tooltip.name == "TilledLand":
			get_node("HUD/ToolTip").text = (
			str(int(tooltip.get_parent().water_level*100)) + 
			"% Watered"
			)
	else:
		get_node("HUD/ToolTip").text = " "
		
	if !pause_movement:
		if $RagdollTimer.is_stopped():
				$Camera3D.make_current()
		else:
			$"Node3D/Armature/Skeleton3D/Physical Bone Body/Camera3D".make_current()
		if $RagdollTimer.is_stopped():
			#$Camera3D.make_current()
			if $RagdollTimer.is_stopped():
				$Camera3D.make_current()
			else:
				$"Node3D/Armature/Skeleton3D/Physical Bone Body/Camera3D".make_current()
			
			# Add the gravity.
			# Handle jump.
			if (Input.is_action_just_pressed("jump") and is_on_floor()):
				$JumpTimer.start()
				$JumpTimer2.start()
				jumping = true
				jump_animation.rpc()
			if $JumpTimer.is_stopped() and jumping:
				jumping = false
				velocity.y = JUMP_VELOCITY
			#if (Input.is_action_just_pressed("jump") and is_on_floor()) or not $JumpTimer.is_stopped():
				#jump_animation.rpc()
			
			mov_sprint(delta)
			mov_dirs()
			mov_hands()
			if not is_on_floor():
				velocity.y -= gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if not is_on_floor():
			velocity.y -= gravity * delta
	move_and_slide()
	deposit()
	shop()
	if Global.day > 1:
		quotacheck(delta)
	payQuota()
	
	reset_mat.rpc()
	
	

@rpc("call_local")
func reset_mat():
	if get_node("Node3D/Armature/Skeleton3D").get_child(0).get_material_override() != null:
		if get_node("Camera3D/Hand").get_child(0).name != "invis":
			var skel = get_node("Node3D/Armature/Skeleton3D")
			for i in range(0, 3):
				skel.get_child(i).set_material_override(null)


func mov_sprint(delta):
	if Input.is_action_pressed("sprint"):
		SPEED = 7.5
		if is_on_floor() && velocity.length() > 5:
			$Camera3D.rotation.x += (cos((ticks%360)*delta*15))*.00075
	else:
		SPEED = 5.0



func mov_hands():
	if Input.is_action_just_pressed("1"):
		if isunlocked["1"]:
			current_item = 1
			switch_hand.rpc(1)
	elif Input.is_action_just_pressed("2"):
		if isunlocked["2"]:
			current_item = 2
			switch_hand.rpc(2)
	elif Input.is_action_just_pressed("3"):
		if isunlocked["3"]:
			current_item = 3
			switch_hand.rpc(3)
	elif Input.is_action_just_pressed("4"):
		if isunlocked["4"]:
			current_item = 4
			switch_hand.rpc(4)	
	elif Input.is_action_just_pressed("5"):
		if isunlocked["5"]:
			current_item = 5
			switch_hand.rpc(5)
	elif Input.is_action_just_pressed("6"):
		if isunlocked["6"]:
			current_item = 6
			switch_hand.rpc(6)
	if !canFarm and not (current_item == 5) and not (current_item == 4) and not (current_item == 6): return
	if current_item == 5:
		if Input.is_action_just_pressed("m1"):
			Hand.get_child(0).activate()
	elif Input.is_action_pressed("m1"):
		Hand.get_child(0).activate()

func death():
	ragdoll.rpc()
	$RagdollTimer.start()
	
@rpc("call_local", "any_peer")
func ragdoll():
	is_ragdoll = true
	ragdoll_opos = global_position
	ragdoll_helper.call_deferred()

func ragdoll_helper():
	$"Node3D/Armature/Skeleton3D/Physical Bone Body/CollisionShape3D".disabled = false
	$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_l/CollisionShape3D".disabled = false
	$"Node3D/Armature/Skeleton3D/Physical Bone upperleg_l/CollisionShape3D".disabled = false
	$"Node3D/Armature/Skeleton3D/Physical Bone lowerleg_l/CollisionShape3D".disabled = false
	$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/CollisionShape3D".disabled = false
	$"Node3D/Armature/Skeleton3D/Physical Bone upperleg_r/CollisionShape3D".disabled = false
	$"Node3D/Armature/Skeleton3D/Physical Bone lowerleg_r/CollisionShape3D".disabled = false
	$Node3D/Armature/Skeleton3D.physical_bones_start_simulation()

@rpc("call_local", "any_peer")
func stopragdoll():
	is_ragdoll = false
	stopragdoll_helper.call_deferred()

func stopragdoll_helper():
	$Node3D/Armature/Skeleton3D.physical_bones_stop_simulation()
	$"Node3D/Armature/Skeleton3D/Physical Bone Body/CollisionShape3D".disabled = true
	$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_l/CollisionShape3D".disabled = true
	$"Node3D/Armature/Skeleton3D/Physical Bone upperleg_l/CollisionShape3D".disabled = true
	$"Node3D/Armature/Skeleton3D/Physical Bone lowerleg_l/CollisionShape3D".disabled = true
	$"Node3D/Armature/Skeleton3D/Physical Bone upperarm_r/CollisionShape3D".disabled = true
	$"Node3D/Armature/Skeleton3D/Physical Bone upperleg_r/CollisionShape3D".disabled = true
	$"Node3D/Armature/Skeleton3D/Physical Bone lowerleg_r/CollisionShape3D".disabled = true


@rpc("call_remote","any_peer","reliable")
func mov_dirs():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor() and (not ($Node3D/AnimationPlayer.current_animation == "walk")) and $JumpTimer2.is_stopped():
			walk_animation.rpc()
		velocity.x = direction.x * SPEED + knockbackX
		velocity.z = direction.z * SPEED + knockbackY
	else:
		if is_on_floor() and ((not ($Node3D/AnimationPlayer.current_animation == "idle")) or (not ($Node3D/AnimationPlayer2.current_animation != "idle"))) and $JumpTimer2.is_stopped():
			idle_animation.rpc()
		velocity.x = move_toward(velocity.x, 0, SPEED) + knockbackX
		velocity.z = move_toward(velocity.z, 0, SPEED) + knockbackY

		
@rpc("call_local","any_peer","reliable")
func walk_animation():
	if (not ($Node3D/AnimationPlayer.current_animation == "walk")):
		$Node3D/AnimationPlayer2.stop()
		$Node3D/AnimationPlayer.stop()
	$Node3D/AnimationPlayer.play("walk")

@rpc("call_local","any_peer","reliable")
func idle_animation():
	if (not ($Node3D/AnimationPlayer.current_animation == "idle")) or (not ($Node3D/AnimationPlayer2.current_animation == "idle")):
		$Node3D/AnimationPlayer2.stop()
		$Node3D/AnimationPlayer.stop()
	$Node3D/AnimationPlayer.play("idle")

@rpc("call_local","any_peer","reliable")
func jump_animation():
	if (not ($Node3D/AnimationPlayer2.current_animation == "jump")):
		$Node3D/AnimationPlayer2.stop()
		$Node3D/AnimationPlayer.stop()
	$Node3D/AnimationPlayer2.play("jump")
func deposit():

	if Input.is_action_just_pressed("interact"):
		$DepositTimer.start()
		
	if Input.is_action_just_released("interact"):
		$DepositTimer.stop()
		$DepositTimer.wait_time = 0.5
		plantcount = 0
		
	if Input.is_action_just_pressed("interact"):
		if $Camera3D.get_child(0).get_collider() != null:
			if $Camera3D.get_child(0).get_collider().name == "DepositArea":
				if plantcount > 4:
					plantcount = 0
				if $Stats.crop_counts[plantcount] > 0:
					$Stats.crop_counts[plantcount] -= 1
					$Stats.money += calcReturn(plantcount)

func _on_deposit_timer_timeout():
	if $Camera3D.get_child(0).get_collider() != null:
		if $Camera3D.get_child(0).get_collider().name == "DepositArea":
			if plantcount > 4:
				plantcount = 0
			if $Stats.crop_counts[plantcount] > 0:
				
				if $DepositTimer.wait_time > 0.001:
					$Stats.crop_counts[plantcount] -= 1
					$Stats.money += calcReturn(plantcount)
				elif $DepositTimer.wait_time > 0.0001 && $Stats.crop_counts[plantcount] >= 2:
					$Stats.crop_counts[plantcount] -= 2
					$Stats.money += calcReturn(plantcount) *2
				elif $DepositTimer.wait_time <= 0.0001 && $Stats.crop_counts[plantcount] >= 4:
					$Stats.crop_counts[plantcount] -= 4 
					$Stats.money += calcReturn(plantcount) * 4
				else:
					$Stats.crop_counts[plantcount] -= 1
			else:
				plantcount += 1
				
	if $DepositTimer.wait_time > 0:
		$DepositTimer.wait_time *= 0.90
	


func calcReturn(plantcount) -> float:
	if plantcount == 0:
		return 1.0
	elif plantcount == 1:
		return 4.0
	elif plantcount == 2:
		return 3.75
	elif plantcount == 3:
		return 8.0
	elif plantcount == 4:
		return 5.0
	else:
		return 0


func shop():
	if get_node_or_null("ShopMenu"): return
	if Input.is_action_just_pressed("interact"):
		if $Camera3D.get_child(0).get_collider() != null:
			if $Camera3D.get_child(0).get_collider().name == "ShopArea":
				
				var shp = load("res://Menus/shop.tscn").instantiate()
				shp.name = "ShopMenu"
				add_child(shp)
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				pause_movement = true

			


func quotacheck(delta):
	
	if Global.get_day_name() != "Monday" && (Global.dayfloat - float(Global.day)) < delta:
		quotaCheck = true
		
	if Global.get_day_name() == "Monday":
		plsCheck = true
	
	if Global.get_day_name() == "Monday" && (Global.dayfloat - float(Global.day)) < delta && quotaSecond == false:
		addCheck = false
		addedQuota = 0
	
	if quotacheck:
		if Global.get_day_name() == "Sunday" && (Global.dayfloat - float(Global.day)) < delta:
			quotadue(Global.quotaPrice + addedQuota, delta)
			quotaCheck = false
	
	if Global.get_day_name() == "Monday" && (Global.dayfloat - float(Global.day)) < delta:
		$Stats.moneyPaid = 0
	

func quotadue(price : float, delta):
	if $Stats.moneyPaid >= price:
		if plsCheck:
			plsCheck = false
			addCheck = true
			quotaSecond = false
			print("Quota reached mfs")
	elif quotaSecond != true:
		if plsCheck:
			plsCheck = false
			print("Quota not reached")
			#add thing to say you have not reached quota 
			addedQuota = Global.quotaPrice * 0.5
			quotaSecond = true
	else:
		if plsCheck:
			print("You dieded")
			$Explosion.play(2)
			#you lose :( by explosion
	


func payQuota():
	if Input.is_action_just_pressed("interact"):
		if $Camera3D.get_child(0).get_collider() != null:
			if $Camera3D.get_child(0).get_collider().name == "QuotaArea":
				if $Stats.money <= Global.quotaPrice + addedQuota - $Stats.moneyPaid:
					$Stats.moneyPaid += $Stats.money
					$Stats.money = 0
				else:
					var due = Global.quotaPrice + addedQuota - $Stats.moneyPaid
					$Stats.money -= due
					$Stats.moneyPaid += due


func pushPull(direction: Vector3, delta):
	self.velocity.y += direction.y * 0.7
	knockbackX = direction.x
	knockbackY = direction.z
	isPPactive = true
	
func resetKnock():
	knockbackX = 0
	knockbackY = 0


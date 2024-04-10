extends CharacterBody3D


var sprinting = false
var ticks = 0

var SPEED = 5.0
@export var JUMP_VELOCITY = 8.5
var camera_sense = 0.004
var camera_sense_multiplier = 1.0
@onready var Hand = $Camera3D/Hand
var hoe = preload("res://Tools/Hoe.tscn")
var seeds = preload("res://Tools/bag_of_seeds.tscn")
var scythe = preload("res://Tools/scythe.tscn")
var watering_can = preload("res://Tools/watering_can.tscn")
var pause_movement = false
var seed_bag_save = 0
var plantcount : int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 10.0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority():
		return
	$Camera3D.make_current()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var hud = load("res://Player/hud.tscn").instantiate()
	add_child(hud)
	request_mp_spawned.rpc()
	
@rpc("call_remote","authority","reliable")
func request_mp_spawned():
	var mps = []
	for node in get_node("/root/World/TilledLand").get_children():
		var sgs = {"has_plant":null}
		sgs["position"] = node.position
		sgs["name"] = node.name
		var ip = node.get_node_or_null("PLANT")
		if ip:
			sgs["has_plant"] = true
			sgs["plant_settings"] = ip.quick_settings
			sgs["plant_anim_pos"] = ip.get_node("Plant/PlantBody/AnimationPlayer").current_animation_position
			sgs["plant_is_growing"] = ip.get_node("Plant/PlantBody/AnimationPlayer").is_playing()
		mps.append(sgs)
	request_mp_spawned_callback.rpc_id(multiplayer.get_remote_sender_id(),mps)

@rpc("call_remote","any_peer","reliable")
func request_mp_spawned_callback(mps):
	var tillI = load("res://Farming/tilled_land.tscn")
	for sgs in mps:
		var till = tillI.instantiate()
		till.position = sgs.position
		till.name = sgs.name
		if sgs.has_plant:
			var plant = get_node("/root/World/PlantSpawner").quick_init(sgs.plant_settings.plant_id)
			plant.name = "PLANT"
			plant.get_node("Plant/PlantBody/AnimationPlayer").seek(sgs.plant_anim_pos)
			if sgs.plant_is_growing:
				plant.start_grow()
			till.add_child(plant)
		get_node("/root/World/TilledLand").add_child(till)
	
func _unhandled_input(event):
	if not is_multiplayer_authority(): 
		return
	if pause_movement: return
	var ncams = camera_sense * camera_sense_multiplier
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * ncams)
		$Camera3D.rotate_x(-event.relative.y * ncams)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)

func change_sensitivity(sense):
	camera_sense_multiplier = sense/50.0 + .03

@rpc("call_remote","any_peer","reliable")
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

func _physics_process(delta):
	if get_node("Camera3D/Hand").get_child(0).name == "BagOfSeeds":
		seed_bag_save = get_node("Camera3D/Hand/BagOfSeeds").plant
	if !multiplayer.multiplayer_peer || !is_multiplayer_authority(): return
	ticks += 1
	if Input.is_action_just_released("menu"):
		if !get_node_or_null("Menu"):
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
			"% Grown"
			)
		if tooltip.name == "TilledLand":
			get_node("HUD/ToolTip").text = (
			str(int(tooltip.get_parent().water_level*100)) + 
			"% watered"
			)
	else:
		get_node("HUD/ToolTip").text = " "
		
	if !pause_movement:
		$Camera3D.make_current()
		# Add the gravity.

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
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
	
	

func mov_sprint(delta):
	if Input.is_action_pressed("sprint"):
		SPEED = 16.8
		if is_on_floor() && velocity.length() > 5:
			$Camera3D.rotation.x += (cos((ticks%360)*delta*15))*.00075
	else:
		SPEED = 5.0



func mov_hands():
	if Input.is_action_just_pressed("1"):
		switch_hand.rpc(1)
		switch_hand(1)
	elif Input.is_action_just_pressed("2"):
		switch_hand.rpc(2)
		switch_hand(2)
	elif Input.is_action_just_pressed("3"):
		switch_hand.rpc(3)
		switch_hand(3)
	elif Input.is_action_just_pressed("4"):
		switch_hand.rpc(4)
		switch_hand(4)
	if Input.is_action_pressed("m1"):
		Hand.get_child(0).activate()



func mov_dirs():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)



func deposit():
	print($DepositTimer.wait_time)
	if Input.is_action_just_pressed("interact"):
		$DepositTimer.start()
		
	if Input.is_action_just_released("interact"):
		$DepositTimer.stop()
		$DepositTimer.wait_time = 0.5
		plantcount = 0

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

extends CharacterBody3D


var sprinting = false
var ticks = 0

var SPEED = 5.0
@export var JUMP_VELOCITY = 8.5
var camera_sense = 0.002
@onready var Hand = $Camera3D/Hand
var hoe = preload("res://Tools/Hoe.tscn")
var seeds = preload("res://Tools/bag_of_seeds.tscn")
var scythe = preload("res://Tools/scythe.tscn")

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
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * camera_sense)
		$Camera3D.rotate_x(-event.relative.y * camera_sense)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)



@rpc("call_remote","any_peer","reliable")
func switch_hand(id):
	if id == 1:
		Hand.get_child(0).queue_free()
		var nscn = hoe.instantiate()
		Hand.add_child(nscn)
	if id == 2:
		Hand.get_child(0).queue_free()
		var nscn = seeds.instantiate()
		Hand.add_child(nscn)
	if id == 3:
		Hand.get_child(0).queue_free()
		var nscn = scythe.instantiate()
		Hand.add_child(nscn)
		nscn.init_pos()


func _physics_process(delta):
	if Input.is_action_just_released("scroll_up"):
		print("up")
	if Input.is_action_just_pressed("scroll_down"):
		print("down")
	ticks += 1
	if !multiplayer.multiplayer_peer || !is_multiplayer_authority(): return
	$Camera3D.make_current()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	mov_sprint(delta)
	mov_dirs()
	mov_hands()
	move_and_slide()
	deposit()


func mov_sprint(delta):
	if Input.is_action_pressed("sprint"):
		SPEED = 16.8
		$Camera3D.rotation.x += (cos((ticks%360)*delta*15))*.0015
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
	if Input.is_action_pressed("interact"):
		if $Camera3D.get_child(0).get_collider() != null:
			if $Camera3D.get_child(0).get_collider().name == "DepositArea":
				$DepositTimer.start()
				print("working")
		else:
			$DepositTimer.stop()
			$DepositTimer.time_left - 0.5


func _on_deposit_timer_timeout():
	var count = 0
	if $Stats.cropcount[count] > 0:
		$Stats.cropcount[count] -1 
	else:
		count += 1
	if not Input.is_action_pressed("interact"):
		count = 0

extends CharacterBody3D


var sprinting = false
var ticks = 0

var SPEED = 5.0
const JUMP_VELOCITY = 5.0
var camera_sense = 0.005
@onready var Hand = $Camera3D/Hand
var hoe = preload("res://Prototype/Hoe.tscn")
var seeds = preload("res://Prototype/bag_of_seeds.tscn")
var scythe = preload("res://Prototype/scythe.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 10.0

func _enter_tree():
	print(str(name).to_int())
	set_multiplayer_authority(str(name).to_int())

func _ready():

	if not is_multiplayer_authority():
		return
	$Camera3D.make_current()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
	
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

extends CharacterBody3D



const SPEED = 10.0
const JUMP_VELOCITY = 20.0
var camera_sense = 0.005
var chat = false

var item_to_hold #current item that will be picked up
var item_to_drop #current item that will be dropped
@onready var proto_item = preload("res://Items/item_prototype.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 10.0

func _enter_tree():
	print(str(name).to_int())
	set_multiplayer_authority(str(name).to_int())

func _ready():

	if not is_multiplayer_authority():
		return
	$"Camera/Camera3D".make_current()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
	
func _unhandled_input(event):
	if not is_multiplayer_authority(): 
		return
		
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * camera_sense)
		$"Camera/Camera3D".rotate_x(-event.relative.y * camera_sense)
		$"Camera/Camera3D".rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)

func _physics_process(delta):

	
	if not is_multiplayer_authority(): 
		return
	
	
	$Camera3D.make_current()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("t"):
		chat = true

	if !chat:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	move_and_slide()
#func hold():
	##Checks if hovering over item and sets item to pick up
	#if reach.is_colliding():
		#
		##add if statements for each item
		#if reach.get_collider() != null and reach.get_collider().name == "ItemPrototype":
			#item_to_hold = proto_item.instantiate()
		#
		#else:
			#item_to_hold = null
	#else:
		#item_to_hold = null
	#
	##Checks if item is being held and sets item to drop
	#if hand.get_child_count() != 0:
		##add if statements for each item
		#if hand.get_child(0).name == "ItemPrototype":
			#item_to_drop = proto_item.instantiate()
		#
			#
	#else:
		#item_to_drop = null
		#
		#
	#if Input.is_action_just_pressed("interact"):
		#if item_to_hold != null:
			#if hand.get_child_count() != 0:
				#get_parent().add_child(item_to_drop)
				#item_to_drop.global_transform = hand.global_transform
				#item_to_drop.dropped = true
				#hand.get_child(0).queue_free()
			#reach.get_collider().queue_free()
			#hand.add_child(item_to_hold)
			#item_to_hold.held = true
			#item_to_hold.rotation = hand.rotation
	#
	#if Input.is_action_just_pressed("drop") and item_to_drop != null:
		#get_parent().add_child(item_to_drop)
		#item_to_drop.global_transform = hand.global_transform
		#item_to_drop.dropped = true
		#hand.get_child(0).queue_free()

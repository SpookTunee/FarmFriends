extends CharacterBody3D



const SPEED = 30.0
const JUMP_VELOCITY = 20.0
var camera_sense = 0.005

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
		

func _physics_process(delta):
	
	if !is_multiplayer_authority() || !multiplayer.multiplayer_peer: return
	
	
	$Camera3D.make_current()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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



	move_and_slide()

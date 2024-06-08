extends Node3D



var camera 
var angle := Vector3(0,0,0)
var vardelta

var player 


@export var power : float = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera = get_parent().get_parent()
	player = camera.get_parent()
	var x = cos(camera.rotation.x ) * power
	var y = sin(camera.rotation.x) * power
	var z= sin(player.rotation.y) * power
	
	angle = Vector3(x, y, z)
	print("x = " , cos(camera.rotation.x) , " y = ", sin(camera.rotation.x), "z =" , sin(player.rotation.y))
	#vardelta = delta
	#print(cos(camera.rotation.z))
	#print(x , y , z)


func activate():
	camera.get_parent().pushPull(angle, vardelta)

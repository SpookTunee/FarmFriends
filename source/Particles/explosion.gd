extends Node3D

var size = 1
var explosion_sound = preload("res://Sounds/explosion_sound.tscn")
var pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pos = global_position


func play(sized): 
	size = sized
	
	rppeed.rpc()
	createSound(pos)
	
	
@rpc("call_local")
func rppeed():
	for i in range(0, $Node3D.get_child_count()):
		$Node3D.get_child(i).scale *= size
		$Node3D.get_child(i).set_emitting(true)


func createSound(pos):
	var instance = explosion_sound.instantiate()
	get_node("/root/World").add_child(instance)
	instance.relocate(pos)


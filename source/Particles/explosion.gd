extends Node3D

var size = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play(sized): 
	size = sized
	rppeed.rpc()
	
@rpc("call_local")
func rppeed():
	for i in range(0, $Node3D.get_child_count()):
		$Node3D.get_child(i).scale *= size
		$Node3D.get_child(i).set_emitting(true)

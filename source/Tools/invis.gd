extends Node3D

var parts : Array
var texture = preload("res://Assets/Player/invisShader.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	grug.rpc()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	pass

@rpc("call_local")
func grug():
	var skeleton = get_parent().get_parent().get_parent().get_node("Node3D/Armature/Skeleton3D")
	for i in range(0, skeleton.get_child_count()):
		skeleton.get_child(i).set_material_override(texture)

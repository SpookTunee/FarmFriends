extends Node3D

var parts : Array
var texture = preload("res://Assets/Player/invisShader.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().name != "Hand2":
		grug.rpc()
		print("hello")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	pass

@rpc("call_local")
func grug():
	var skeleton = get_parent().get_parent().get_parent().get_node("Node3D/Armature/Skeleton3D")
	for i in range(0, 3):
		for j in skeleton.get_child(i).get_surface_override_material_count():
			skeleton.get_child(i).set_surface_override_material(j,texture)

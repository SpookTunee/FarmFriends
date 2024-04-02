extends Node3D
var plant = 0
var material = null
const color_list: Array = [
		Color(0.799238,0.737879,0.124763,1),
		Color(0.799999,0.740825,0.064044,1),
		Color(0.295186,0.135547,0.021469,1),
		Color(0.799999,0.208949,0.010663,1),
		Color(0.338115,0.117821,0.034656,1)
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	material = get_node("seedPouchMesh").get_surface_override_material(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("scroll_up"):
		plant += 1
	elif Input.is_action_just_pressed("scroll_down"):
		plant -= 1
	if (plant > 4):
		plant = 0
	if (plant == -1):
		plant = 4
	material.albedo_color = color_list[plant]
	$seedPouchMesh.set_surface_override_material(1, material)
	


func activate():
	var Look = get_parent().get_parent().get_child(0)
	if Look.get_collider() && (Look.get_collider().name == "TilledLand"):
		Look.get_collider().get_parent().grow(plant)

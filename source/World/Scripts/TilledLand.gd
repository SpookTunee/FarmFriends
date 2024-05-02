extends Node

var tilledLand = preload("res://Farming/tilled_land.tscn")

var till_count = 0
var tillposs = []

@rpc("any_peer","call_remote","reliable")
func spawn_till(count,pos,rot):
	instant_till(multiplayer.get_remote_sender_id(),count,pos,rot)
	
@rpc("any_peer","call_remote","reliable")
func grow_plant(id: String, plant: int):
	get_node(id).gplant(plant)
	
@rpc("any_peer","call_remote","reliable")
func harvest_plant(id: String):
	get_node(id).harvest()
	
func instant_till(id,count,pos,rot):
	till_count += 1
	var till = tilledLand.instantiate()
	till.name = "mpSpawned_" + str(id) + "_till_" + str(count)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.from_hsv(31.0/255.0,1.0,43.0/100.0,1.0)
	till.get_node("CSGTorus3D").material = mat
	get_node("/root/World/TilledLand").add_child(till)
	till.position = pos
	till.rotation = rot

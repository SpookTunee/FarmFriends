extends Node

var tilledLand = preload("res://Prototype/Plant_prototype/tilled_land.tscn")

var till_count = 0
var tillposs = []

@rpc("any_peer","call_remote","reliable")
func spawn_till(count,pos):
	instant_till(multiplayer.get_remote_sender_id(),count,pos)
	
@rpc("any_peer","call_remote","reliable")
func grow_plant(id: String):
	get_node(id).gplant()
	
@rpc("any_peer","call_remote","reliable")
func harvest_plant(id: String):
	get_node(id).harvest()
	
func instant_till(id,count,pos):
	till_count += 1
	var till = tilledLand.instantiate()
	till.name = "mpSpawned_" + str(id) + "_till_" + str(count)
	get_node("/root/World/TilledLand").add_child(till)
	till.position = (pos)

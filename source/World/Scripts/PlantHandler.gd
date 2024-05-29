extends Node

var newday: bool = true

func _process(delta):
	if newday && ((Global.dayfloat-float(Global.day)) >= 0.0):
		handle_plant_growing(true)
		newday = false
	if !newday && ((Global.dayfloat-float(Global.day)) >= 0.333):
		handle_plant_growing(false)
		newday = true
	handle_plant_watering(delta/300)
	
func handle_plant_watering(delta):
	for tland in get_node("../TilledLand").get_children():
		tland.reduce_water(delta)
		if tland.get_node_or_null("PLANT"):
			tland.get_node("PLANT").water_change()

@rpc("any_peer","call_remote","unreliable")
func drought(info:Dictionary):
	for tl in info.keys():
		get_node("../TilledLand/" + tl).water_level = info[tl]

func handle_plant_growing(gon):
	if gon:
		for tland in get_node("../TilledLand").get_children():
			if tland.get_node_or_null("PLANT"):
				tland.get_node("PLANT").dnmod(true)
	else:
		for tland in get_node("../TilledLand").get_children():
			if tland.get_node_or_null("PLANT"):
				tland.get_node("PLANT").dnmod(false)

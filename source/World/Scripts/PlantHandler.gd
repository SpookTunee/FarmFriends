extends Node

var newday: bool = true

func _process(delta):
	if newday && ((Global.dayfloat-float(Global.day)) >= 0.0):
		handle_plant_growing(true)
		newday = false
	if !newday && ((Global.dayfloat-float(Global.day)) >= 0.333):
		handle_plant_growing(false)
		newday = true
	handle_plant_watering(delta/20)

func handle_plant_watering(delta):
	for tland in get_node("../TilledLand").get_children():
		tland.reduce_water(delta)
		if tland.get_node_or_null("PLANT"):
			tland.get_node("PLANT").water_change()


func handle_plant_growing(gon):
	if gon:
		for tland in get_node("../TilledLand").get_children():
			if tland.get_node_or_null("PLANT"):
				tland.get_node("PLANT").start_grow()
	else:
		for tland in get_node("../TilledLand").get_children():
			if tland.get_node_or_null("PLANT"):
				tland.get_node("PLANT").stop_grow()

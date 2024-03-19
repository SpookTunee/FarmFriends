extends Node3D

var wheatplant = preload("res://Prototype/Plant_prototype/plant_prototype.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func grow():
	if get_node_or_null("PLANT"): return
	gplant()
	$/root/World/TilledLand.grow_plant.rpc(self.name)

func gplant():
	var growplant = get_node("/root/World/PlantSpawner").quick_init(Global.Plants.WHEAT)
	growplant.name = "PLANT"
	add_child(growplant)
	growplant.get_node("Plant/PlantBody/AnimationPlayer").play("Plant_Growth_anim")

func harvest_plant():
	if !get_node_or_null("PLANT"): return
	harvest()
	$/root/World/TilledLand.harvest_plant.rpc(self.name)
	get_node("/root/World/mpSpawned_" + str(multiplayer.get_unique_id())).get_node("Stats").add_wheat()
	
func harvest():
	get_node("PLANT").queue_free()
	

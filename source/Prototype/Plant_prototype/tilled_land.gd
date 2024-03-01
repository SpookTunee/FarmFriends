extends Node3D

var wheatplant = preload("res://Prototype/Plant_prototype/plant_prototype.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func grow():
	if get_node_or_null("PLANT"): return
	get_node("/root/World/").spawn_wheatplant.rpc(self.name.replace("self",str(multiplayer.get_unique_id())),get_node("/root/World/").pcount)
	gplant("self",get_node("/root/World/").pcount)
	get_node("/root/World/").pcount += 1
	
func gplant(id: String, ids):
	var growplant = wheatplant.instantiate()
	growplant.name="mpSpawned_" + id + "_wheatplant_" + str(ids)
	add_child(growplant)
	growplant.get_node("Plant/PlantBody/AnimationPlayer").play("Plant_Growth_anim")

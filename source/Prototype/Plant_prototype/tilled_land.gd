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
	var growplant = wheatplant.instantiate()
	growplant.name = "PLANT"
	add_child(growplant)
	growplant.get_node("Plant/PlantBody/AnimationPlayer").play("Plant_Growth_anim")

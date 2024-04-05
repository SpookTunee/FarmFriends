extends Node3D

var wheatplant = preload("res://Farming/plant_prototype.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func grow(plant):
	if get_node_or_null("PLANT"): return
	gplant(plant)
	$/root/World/TilledLand.grow_plant.rpc(self.name,plant)

func gplant(plant):
	var growplant = get_node("/root/World/PlantSpawner").quick_init(plant)
	growplant.name = "PLANT"
	add_child(growplant)
	growplant.get_node("Plant/PlantBody/AnimationPlayer").play("Plant_Growth_anim")

func harvest_plant(plant):
	if !get_node_or_null("PLANT"): return
	$/root/World/TilledLand.harvest_plant.rpc(self.name)
	if get_node("PLANT/Plant/PlantBody/AnimationPlayer").current_animation_position == 1:
		get_node("/root/World/mpSpawned_" + str(multiplayer.get_unique_id())).get_node("Stats").crop_counts[plant] += get_node("PLANT").crop_yield
	harvest()
	
func harvest():
	get_node("PLANT").queue_free()
	

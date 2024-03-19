extends Node3D
class_name PlantBase

@export var grow_time: float
@export var plant_model: Mesh
@export var crop_yield: int
@export_enum("None","Plains", "Mountainous", "River", "Forest") var terrain_good : int
@export_enum("None","Plains", "Mountainous", "River", "Forest") var terrain_bad : int
@export_enum("None","Plains", "Mountainous", "River", "Forest") var terrain_bad_2 : int = 0

func _ready():
	$Plant/PlantBody.mesh = plant_model

func with_vars(Variables: Dictionary):
	var n = load("res://Farming/plant_base.tscn").instantiate()
	n.grow_time = Variables.grow_time
	n.plant_model = Variables.plant_model
	n.crop_yield = Variables.crop_yield
	n.terrain_good = Variables.terrain_good
	n.terrain_bad = Variables.terrain_bad
	if Variables.has("terrain_bad_2"):
		n.terrain_bad_2 = Variables.terrain_bad_2
	else:
		n.terrain_bad_2 = 0
	return n

func quick_init(Plant: int):
	var settings = {}
	
	if Plant == Global.Plants.WHEAT:
		settings = {"grow_time":0.5,"plant_model":load("res://Assets/Plants/wheat.obj"),"crop_yield":5,"terrain_good":Global.Regions.PLAINS,"terrain_bad":Global.Regions.MOUNTAINOUS, "terrain_bad_2":Global.Regions.FOREST}
	elif Plant == Global.Plants.CORN:
		settings = {"grow_time":1.5,"plant_model":load("res://Assets/Plants/corn.obj"),"crop_yield":5,"terrain_good":Global.Regions.PLAINS,"terrain_bad":Global.Regions.RIVER,"terrain_bad_2":Global.Regions.MOUNTAINOUS}
	elif Plant == Global.Plants.POTATO:  # Potatoes are special, update this code later.
		settings = {"grow_time":0.5,"plant_model":load("res://Assets/Plants/potato.obj"),"crop_yield":5,"terrain_good":Global.Regions.MOUNTAINOUS,"terrain_bad":Global.Regions.RIVER}
	elif Plant == Global.Plants.CARROT:
		settings = {"grow_time":2.5,"plant_model":load("res://Assets/Plants/carrot.obj"),"crop_yield":3,"terrain_good":Global.Regions.RIVER,"terrain_bad":Global.Regions.MOUNTAINOUS}
	elif Plant == Global.Plants.MUSHROOM:
		settings = {"grow_time":2.5,"plant_model":load("res://Assets/Plants/mushroom.obj"),"crop_yield":3,"terrain_good":Global.Regions.RIVER,"terrain_bad":Global.Regions.MOUNTAINOUS}
	
	return with_vars(settings)

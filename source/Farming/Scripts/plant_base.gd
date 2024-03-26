extends Node3D
class_name PlantBase

@export_category("Plant Data")
@export var grow_time: float
@export var plant_model: Mesh
@export var crop_yield: int
@export_enum("Wheat","Corn","Potato","Carrot","Mushroom") var plant_id: int
@export_category("Terrain Preference")
@export_enum("None","Plains", "Mountainous", "River", "Forest") var terrain_good : int
@export_enum("None","Plains", "Mountainous", "River", "Forest") var terrain_bad : int
@export_enum("None","Plains", "Mountainous", "River", "Forest") var terrain_bad_2 : int = 0
@export_category("Default Transformations")
@export var default_position: Vector3 = Vector3(0.0,0.0,0.0)
@export var default_scale: Vector3 = Vector3(1.0,1.0,1.0)
@export var collider_default_position: Vector3 = Vector3(0.0,0.0,0.0)
@export var collider_default_scale: Vector3 = Vector3(1.0,1.0,1.0)

var is_in_preffered_terrain: int = 0  #1=true, 0=false, -1=bad terrain
var start_grow_time: float = 0.0
var actual_grow_time: float = 0.0


func _physics_process(delta):
	pass









func _ready():
	$Plant/PlantBody.mesh = plant_model
	$Plant.position = default_position
	$Plant.scale = default_scale
	$PlantBox.scale = collider_default_scale
	$PlantBox.position = collider_default_position
	start_grow_time = Global.dayfloat
	#dayfloat is 0.0 at 1/6 the way through the day
	

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
	n.default_position = Variables.default_position
	n.default_scale = Variables.default_scale
	n.collider_default_position = Variables.collider_default_position
	n.collider_default_scale = Variables.collider_default_scale
	n.plant_id = Variables.plant_id
	return n

func quick_init(Plant: int):
	var settings = {}
	
	if Plant == Global.Plants.WHEAT:
		settings = {
			"grow_time":				0.5,
			"plant_model":				load("res://Assets/Plants/wheat.obj"),
			"crop_yield":				5,
			"terrain_good":				Global.Regions.PLAINS,
			"terrain_bad":				Global.Regions.MOUNTAINOUS,
			"terrain_bad_2":			Global.Regions.FOREST,
			"default_position":			Vector3(-0.254,0,0.16),
			"default_scale":			Vector3(0.5,0.5,0.5),
			"collider_default_position":Vector3(0.0,0.1,0.0),
			"collider_default_scale":	Vector3(1.0,1.6,1.0),
			}
	elif Plant == Global.Plants.CORN:
		settings = {
			"grow_time":				1.5,
			"plant_model":				load("res://Assets/Plants/corn.obj"),
			"crop_yield":				5,
			"terrain_good":				Global.Regions.PLAINS,
			"terrain_bad":				Global.Regions.MOUNTAINOUS,
			"terrain_bad_2":			Global.Regions.RIVER,
			"default_position":			Vector3(0.0,0,0.0),
			"default_scale":			Vector3(1.0,1.0,1.0),
			"collider_default_position":Vector3(0.0,0.13,0.0),
			"collider_default_scale":	Vector3(1.0,2.6,1.0),
			}
	elif Plant == Global.Plants.POTATO:  # Potatoes are special, update this code later.
		settings = {
			"grow_time":				2.0,
			"plant_model":				load("res://Assets/Plants/potato.obj"),
			"crop_yield":				6,
			"terrain_good":				Global.Regions.MOUNTAINOUS,
			"terrain_bad":				Global.Regions.RIVER,
			"default_position":			Vector3(0.0,-0.44,0.0),
			"default_scale":			Vector3(1.0,1.5,1.0),
			"collider_default_position":Vector3(0.0,0.0,0.0),
			"collider_default_scale":	Vector3(1.5,0.5,1.5),
			}
	elif Plant == Global.Plants.CARROT:
		settings = {
			"grow_time":				2.5,
			"plant_model":				load("res://Assets/Plants/carrot.obj"),
			"crop_yield":				3,
			"terrain_good":				Global.Regions.RIVER,
			"terrain_bad":				Global.Regions.MOUNTAINOUS,
			"default_position":			Vector3(0.0,-0.2,0.0),
			"default_scale":			Vector3(1.6,1.0,1.6),
			"collider_default_position":Vector3(0.0,-0.2,0.0),
			"collider_default_scale":	Vector3(2.3,0.75,2.3),
			}
	elif Plant == Global.Plants.MUSHROOM:
		settings = {
			"grow_time":				1.0,
			"plant_model":				load("res://Assets/Plants/mushroom.obj"),
			"crop_yield":				6,
			"terrain_good":				Global.Regions.PLAINS,
			"terrain_bad":				Global.Regions.MOUNTAINOUS,
			"terrain_bad_2":			Global.Regions.FOREST,
			"default_position":			Vector3(0.0,0.3,0.0),
			"default_scale":			Vector3(0.1,0.1,0.1),
			"collider_default_position":Vector3(0.0,0.0,0.0),
			"collider_default_scale":	Vector3(0.9,0.76,0.9),
			}
	else:
		print("Crop instancing error")
		return
	settings["plant_id"] = Plant
	
	return with_vars(settings)

extends Node3D

@export var grow_time: int
@export var plant_model: Mesh
@export var crop_id: String
@export var crop_yield: int
@export_enum("None","Plains", "Mountainous", "River") var terrain_good : int
@export_enum("None","Plains", "Mountainous", "River") var terrain_bad : int
@export_enum("None","Plains", "Mountainous", "River") var terrain_bad_2 : int


enum Regions {
	NONE,
	PLAINS,
	MOUNTAINOUS,
	RIVER
}

func _ready():
	$Plant/PlantBody.mesh = plant_model

func with_vars(Variables: Dictionary):
	var n = load("res://Prototype/plant_base.tscn")
	n.grow_time = Variables.grow_time
	n.plant_model = Variables.plant_model
	n.crop_id= Variables.crop_id
	n.crop_yield = Variables.crop_yield
	n.terrain_good = Variables.terrain_good
	n.terrain_bad = Variables.terrain_bad
	n.terrain_bad_2 = Variables.terrain_bad_2
	return n

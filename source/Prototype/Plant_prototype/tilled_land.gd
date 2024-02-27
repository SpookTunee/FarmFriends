extends Node3D

var plant = preload("res://Prototype/Plant_prototype/plant_prototype.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func grow():
	if get_node_or_null("PLANT"): return
	var growplant = plant.instantiate()
	growplant.name="PLANT"
	add_child(growplant)
	growplant.get_node("Plant/PlantBody/AnimationPlayer").play("Plant_Growth_anim")

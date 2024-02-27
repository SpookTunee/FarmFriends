extends Node3D

var plant = preload("res://Prototype/Plant_prototype/plant_prototype.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func grow():
	var growplant = plant.instanciate()
	add_child(growplant)

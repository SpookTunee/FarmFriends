extends Node

@export var wheat_count: int = 0


func add_wheat():
	wheat_count += 1

func _physics_process(_delta):
	get_node("../Label3D").text = str(wheat_count) + " Wheat"

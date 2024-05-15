extends Node3D

@export var force : int = 30
var inRad : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	for i in $Area3D.get_overlapping_areas():
		if i.name == "Hitbox":
			var force_dir = ($Origin.position.direction_to(i.position)) # finds direction
			force_dir = Vector3(0,0,0) - force_dir
			i.get_parent().pushPull(force_dir)
			



##only applies to players in area :: adds player to group
#func _on_area_3d_body_entered(body): #dw about it
	#if body.get_class() == "CharacterBody3D":
		#inRad.append(body)
#
##deletes exited players from array
#func _on_area_3d_body_exited(body):
	#if body.get_class() == "CharacterBody3D":
		#inRad.erase(body)


# THIS NEEDS TO ACTIVATE ALWAYS NOT JUST ONCE -- CHANGE PLAYER SCRIPT
func activate():
	var force_dir : Vector3
	print("active")
	
	for i in inRad:
		
		force_dir = 1/($Origin.translation.direction_to(i.translation)) # finds direction
		print(i.name + ":  " + force_dir)
		
		i.pushPull(force_dir)

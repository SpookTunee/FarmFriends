extends Node3D

var inRad : Array
var force_dir : Vector3
var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate():
	for i in $Area3D.get_overlapping_areas():
		if i.name == "Hitbox":
			if i.get_parent() != self.get_parent().get_parent().get_parent():
					
				force_dir = (Vector3(0,0,0) - Vector3($Origin.global_position.x - (i.get_parent().global_position.x), -($Origin.global_position.y - (i.get_parent().global_position.y)), $Origin.global_position.z - (i.get_parent().global_position.z))) # finds direction
				#print(force_dir)
				#force_dir = Vector3(0,0,0) - force_dir
				print("on")
				i.get_parent().pushPull(force_dir, 0.0)

func _physics_process(delta):
	pass



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



func _on_area_3d_area_exited(area):
	pass
	#if area.name == "Hitbox":
			#if area.get_parent() != self.get_parent().get_parent().get_parent():
				#area.get_parent().resetKnock()

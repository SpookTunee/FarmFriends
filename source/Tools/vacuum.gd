extends Node3D

@export var force : int = 30
var inRad : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





#only applies to players in area :: adds player to group
func _on_area_3d_body_entered(body):
	if body != self.get_parent().get_parent().get_parent(): #dw about it
		if body.is_in_group("player"):
			inRad.append(body)

#deletes exited players from array
func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		inRad.erase(body)


# THIS NEEDS TO ACTIVATE ALWAYS NOT JUST ONCE -- CHANGE PLAYER SCRIPT
func activate():
	var force_dir : Vector3
	
	

	
	for i in inRad:
		force_dir = self.translation.direction_to(i.translation) # finds direction
		
		
		i.apply_impulse(0, force_dir * force)

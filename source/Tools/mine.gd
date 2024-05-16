extends RigidBody3D
var force_dir : Vector3
var deltaP
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	deltaP = delta

func instance():
	global_position = get_parent().find_child("Spawner").global_position


func _on_detect_zone_area_entered(area):
	for i in $ExplosionZone.get_overlapping_areas():
		if i.name == "Hitbox":
		
					
			force_dir = (Vector3(0,0,0) - Vector3(global_position.x - (i.get_parent().global_position.x), -(global_position.y - (i.get_parent().global_position.y)) - 0.1, global_position.z - (i.get_parent().global_position.z))) * 100 # finds direction
				#print(force_dir)
				#force_dir = Vector3(0,0,0) - force_dir
			
			i.get_parent().pushPull(force_dir, deltaP)
			
	


func _on_explosion_zone_area_exited(area):
	if area.name == "Hitbox":
		area.get_parent().resetKnock()

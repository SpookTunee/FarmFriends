extends RigidBody3D
var force_dir : Vector3
var deltaP
var done : bool = false
var delete : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	deltaP = delta
	
	

func instance(pos):
	global_position = pos


func _on_detect_zone_area_entered(area):
	for i in $ExplosionZone.get_overlapping_areas():
		if i.name == "Hitbox":
		
					
			force_dir = (Vector3(0,0,0) - Vector3(global_position - i.get_parent().global_position)).normalized() * 10 # finds direction
				#print(force_dir)
				#force_dir = Vector3(0,0,0) - force_dir
			
			$Explosion.play(1)
			i.get_parent().pushPull(force_dir, deltaP)
			i.get_parent().recieve_damage.rpc(2)
			done = true
			$Backup.start()
			


#
#func _on_explosion_zone_area_exited(area):
	#if done == true:
		#if area.name == "Hitbox":
			#area.get_parent().resetKnock()
		
				
				

	

func _on_backup_timeout():
	#for i in $ExplosionZone.get_overlapping_areas():
		#if i.name == "Hitbox":
			#i.get_parent().resetKnock()
	remove.rpc()


@rpc("call_local") #help
func remove():
	queue_free()

extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	$AnimationPlayer.play("hoe")
	if multiplayer.multiplayer_peer:
		var Look = get_parent().get_parent().get_child(0)
		if Look.get_collider() && (Look.get_collider().name == "Terrain"):
			var lpos = Look.get_collision_point()
			lpos.x = (int(lpos.x)/1.25)*1.25 - 0.625
			lpos.z = (int(lpos.z)/1.25)*1.25 - 0.625
			if !(Vector2((lpos.x),(lpos.z)) in get_node("/root/World/TilledLand").tillposs):
				get_node("/root/World/TilledLand").tillposs.insert(0,Vector2(lpos.x,lpos.z))
				$/root/World/TilledLand.instant_till(multiplayer.get_unique_id(),$/root/World/TilledLand.till_count+1,lpos)
				$/root/World/TilledLand.spawn_till.rpc($/root/World/TilledLand.till_count,lpos)


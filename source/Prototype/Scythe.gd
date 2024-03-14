extends Node3D


func activate():
	$scythe/AnimationPlayer.play("scythe")
	if multiplayer.multiplayer_peer:
		var Look = $scythe/Area3D
		var con
		for i in Look.get_overlapping_areas():
			if i.name == "PlantBox":
				con = i
				break
		if con:
			#if !con.get_parent().get_node("Plant/PlantBody/AnimationPlayer").is_playing():
			con.get_parent().get_parent().harvest_plant()

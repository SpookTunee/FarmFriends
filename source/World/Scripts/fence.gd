extends Path3D
var fence = preload("res://Assets/Buildings/protoFence.obj")

func start():
	var pf = get_node("PathFollow3D")
	pf.progress_ratio = 1.0
	var l = pf.progress
	pf.progress_ratio = 0.0
	l = l*.90
	for i in range(int(l)):
		pf.progress_ratio = (float(i)/float(l))
		var b = MeshInstance3D.new()
		b.mesh = fence
		var Look = RayCast3D.new()
		Look.target_position = Vector3(0,-30,0)
		Look.collision_mask = 2
		Look.position = pf.position
		get_node("root/World").add_child(Look)
		if Look.get_collider() && (Look.get_collider().name == "Terrain"):
			print(Look.get_collision_point())
			b.position = Look.get_collision_point()
			b.rotation = Look.get_collision_normal()
			add_child(b)
		Look.queue_free()

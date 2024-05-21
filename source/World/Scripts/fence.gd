extends Node3D

var fenc = preload("res://Farming/fence.tscn")

var cs = []
var prev = []
var pim = []
var prog = []
var max = [] 

func _ready():
	for i in get_children():
		var pf = i.get_node("PathFollow3D")
		pf.progress_ratio = 1.0
		max.append(int(pf.progress)*0.85)
		pf.progress_ratio = 0.0
		prev.append(null)
		pim.append(true)
		prog.append(0)
		cs.append(i)

func step(i):
	
	var b = fenc.instantiate()
	var Look = cs[i].get_node("PathFollow3D/RayCast3D")
	var pf = cs[i].get_node("PathFollow3D")
	if Look.get_collider() && (Look.get_collider().name == "Terrain"):
		b.position = Look.get_collision_point()
		if prev[i]:
			b.look_at_from_position(b.position,prev[i].position)
			if pim[i]:
				pim[i] = false
				prev[i].rotation = b.rotation
		#b.rotation = Look.get_collision_normal() + Vector3(0,b.rotation.y,0)
		get_node("/root/World/Fences").add_child(b)
		prev[i] = b
	pf.progress_ratio = float(prog[i])/float(max[i])
	prog[i] += 1
	

func _physics_process(delta):
	for i in range(len(cs)):
		if prog[i] > max[i]: continue
		step(i)

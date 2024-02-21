extends Node3D

@export var length: float = 64.0
@export var width: float = 64.0
@export var subdivisions: float = 64.0 #MUST BE DIVISIBLE BY 2

func yFun(x,z):
	return sin(x/10)*cos(z/10)

func _ready():
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var coll = []
	
	for x in range(subdivisions-1):
		for y in range(subdivisions-1):
			var xtl = float(length/subdivisions*((x)-1.0))
			var ztl = float(width/subdivisions*((y)))
			
			var xtr = float(length/subdivisions*((x)))
			var ztr = float(width/subdivisions*((y)))
			
			var xbl = float(length/subdivisions*((x)-1.0))
			var zbl = float(width/subdivisions*((y)-1.0))
			
			var xbr = float(length/subdivisions*((x)))
			var zbr = float(width/subdivisions*((y)-1.0))
			
			coll.append(Vector3(xbl, yFun(xbl,zbl), zbl))
			coll.append(Vector3(xbr, yFun(xbr,zbr), zbr))
			coll.append(Vector3(xtr, yFun(xtr,ztr), ztr))
			coll.append(Vector3(xtl, yFun(xtl,ztl), ztl))
			coll.append(Vector3(xbl, yFun(xbl,zbl), zbl))
			coll.append(Vector3(xbr, yFun(xbr,zbr), zbr))
	
			st.add_vertex(Vector3(xtl, yFun(xtl,ztl), ztl))
			st.add_vertex(Vector3(xbr, yFun(xbr,zbr), zbr))
			st.add_vertex(Vector3(xtr, yFun(xtr,ztr), ztr))
			st.add_vertex(Vector3(xtl, yFun(xtl,ztl), ztl))
			st.add_vertex(Vector3(xbl, yFun(xbl,zbl), zbl))
			st.add_vertex(Vector3(xbr, yFun(xbr,zbr), zbr))
	
	
	st.generate_normals()
	var coll2 = ConcavePolygonShape3D.new()
	coll2.set_faces(PackedVector3Array(coll))
	$StaticBody3D/CollisionShape3D.shape = coll2
	#st.generate_tangents()
	# Commit to a mesh.
	var mesh = st.commit()
	$MeshInstance3D.mesh = mesh

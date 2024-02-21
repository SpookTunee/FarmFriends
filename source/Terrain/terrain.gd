extends Node3D

@export var length: float = 64.0
@export var width: float = 64.0
@export var subdivisions: float = 64.0

func yFun(x,z):
	return sin(x/10)*cos(z/10)*4

func _ready():
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var coll = []
	
	for x in range(subdivisions-1):
		for y in range(subdivisions-1):
			var xtl = (length/subdivisions*(x-1))
			var ztl = (width/subdivisions*(y))
			
			var xtr = (length/subdivisions*(x))
			var ztr = (width/subdivisions*(y))
			
			var xbl = (length/subdivisions*(x-1))
			var zbl = (width/subdivisions*(y-1))
			
			var xbr = (length/subdivisions*(x))
			var zbr = (width/subdivisions*(y-1))
			
			st.add_vertex(Vector3(xtl, yFun(xtl,ztl), ztl))
			st.add_vertex(Vector3(xbr, yFun(xbr,zbr), zbr))
			st.add_vertex(Vector3(xtr, yFun(xtr,ztr), ztr))
			st.add_vertex(Vector3(xtl, yFun(xtl,ztl), ztl))
			st.add_vertex(Vector3(xbl, yFun(xbl,zbl), zbl))
			st.add_vertex(Vector3(xbr, yFun(xbr,zbr), zbr))
			
			
			coll.append(Vector3(xtl, yFun(xtl,ztl), ztl))
			coll.append(Vector3(xbr, yFun(xbr,zbr), zbr))
			coll.append(Vector3(xtr, yFun(xtr,ztr), ztr))
			coll.append(Vector3(xtl, yFun(xtl,ztl), ztl))
			coll.append(Vector3(xbl, yFun(xbl,zbl), zbl))
			coll.append(Vector3(xbr, yFun(xbr,zbr), zbr))
	
	
	st.generate_normals()
	var coll2 = ConcavePolygonShape3D.new()
	coll2.set_faces(PackedVector3Array(coll))
	$StaticBody3D/CollisionShape3D.shape = coll2
	var mesh = st.commit()
	$MeshInstance3D.mesh = mesh

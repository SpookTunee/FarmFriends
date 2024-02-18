extends Node3D

@export var length: float = 8.0
@export var width: float = 8.0
@export var subdivisions: float = 128.0 #MUST BE DIVISIBLE BY 2


func _ready():
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	
	#st.set_uv(Vector2(0, 0))
	#st.add_vertex(Vector3(-1, -1, 0))
#
	#st.set_uv(Vector2(0, 1))
	#st.add_vertex(Vector3(-1, 1, 0))
#
	#st.set_uv(Vector2(1, 1))
	#st.add_vertex(Vector3(1, 1, 0))
	#
	#st.set_uv(Vector2(0, 0))
	#st.add_vertex(Vector3(1, 1, 0))
	#
	#st.set_uv(Vector2(0, 1))
	#st.add_vertex(Vector3(1, -1, 0))
	#
	#st.set_uv(Vector2(1, 1))
	#st.add_vertex(Vector3(-1, -1, 0))
	
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
			
			
			#st.set_uv(Vector2(1, 1))
			st.add_vertex(Vector3(xtr, sin(xtr), ztr))
			
			#st.set_uv(Vector2(0, 0))
			st.add_vertex(Vector3(xbl, sin(xbl), zbl))

			#st.set_uv(Vector2(0, 1))
			st.add_vertex(Vector3(xtl, sin(xtl), ztl))
			
			#st.set_uv(Vector2(1, 1))
			st.add_vertex(Vector3(xtr, sin(xtr), ztr))
			
			#st.set_uv(Vector2(0, 1))
			st.add_vertex(Vector3(xbr, sin(xbr), zbr))
			
			#st.set_uv(Vector2(0, 0))
			st.add_vertex(Vector3(xbl, sin(xbl), zbl))
			
			#print("running")
	
	st.generate_normals()
	#st.generate_tangents()
	# Commit to a mesh.
	var mesh = st.commit()
	$MeshInstance3D.mesh = mesh

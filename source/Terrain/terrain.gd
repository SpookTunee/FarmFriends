extends Node3D

@export var length: float = 2.0
@export var width: float = 2.0
@export var subdivisions: float = 8.0 #MUST BE DIVISIBLE BY 2


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
	
	for x in range(subdivisions/1.0):
		for y in range(subdivisions/1.0):
			var xtl = float(length/subdivisions*((x*2.0)-1.0))
			var ytl = float(width/subdivisions*((y*2.0)))
			
			var xtr = float(length/subdivisions*((x*2.0)))
			var ytr = float(width/subdivisions*((y*2.0)))
			
			var xbl = float(length/subdivisions*((x*2.0)-1.0))
			var ybl = float(width/subdivisions*((y*2.0)-1.0))
			
			var xbr = float(length/subdivisions*((x*2.0)))
			var ybr = float(width/subdivisions*((y*2.0)-1.0))
			
			
			#st.set_uv(Vector2(0, 0))
			st.add_vertex(Vector3(xbl, ybl, 0))

			#st.set_uv(Vector2(0, 1))
			st.add_vertex(Vector3(xtl, ytl, 0))

			#st.set_uv(Vector2(1, 1))
			st.add_vertex(Vector3(xtr, ytr, 0))
			
			#st.set_uv(Vector2(0, 1))
			st.add_vertex(Vector3(xbr, ybr, 0))
			
			#st.set_uv(Vector2(0, 0))
			st.add_vertex(Vector3(xbl, ybl, 0))

			#st.set_uv(Vector2(1, 1))
			st.add_vertex(Vector3(xtr, ytr, 0))
			
			#print("running")
	
	st.generate_normals()
	#st.generate_tangents()
	# Commit to a mesh.
	var mesh = st.commit()
	$MeshInstance3D.mesh = mesh

extends Node3D

@export var length: float = 2.0
@export var width: float = 2.0
@export var subdivisions: float = 4.0 #MUST BE DIVISIBLE BY 2


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
	
	for x in range(subdivisions/2.0):
		for y in range(subdivisions/2.0):
			var xtl1 = float(length/subdivisions*((x*2.0)-1.0))
			var ytl1 = float(width/subdivisions*((y*2.0)-1.0))
			
			var xtr1 = float(length/subdivisions*((x*2.0)))
			var ytr1 = float(width/subdivisions*((y*2.0)-1.0))
			
			var xbl1 = float(length/subdivisions*((x*2.0)-1.0))
			var ybl1 = float(width/subdivisions*((y*2.0)))
			
			var xbr2 = float(length/subdivisions*((x*2.0)-1.0))
			var ybr2 = float(width/subdivisions*((y*2.0)-1.0))
			
			var xtr2 = float(length/subdivisions*((x*2.0)))
			var ytr2 = float(width/subdivisions*((y*2.0)-1.0))
			
			var xbl2 = float(length/subdivisions*((x*2.0)-1.0))
			var ybl2 = float(width/subdivisions*((y*2.0)))
			
			st.set_uv(Vector2(0, 0))
			st.add_vertex(Vector3(xbl1, ybl1, 0))

			st.set_uv(Vector2(0, 1))
			st.add_vertex(Vector3(xtl1, ytl1, 0))

			st.set_uv(Vector2(1, 1))
			st.add_vertex(Vector3(xtr1, ytr1, 0))
			
			st.set_uv(Vector2(0, 0))
			st.add_vertex(Vector3(xbr2, ybr2, 0))

			st.set_uv(Vector2(0, 1))
			st.add_vertex(Vector3(xtr2, ytr2, 0))

			st.set_uv(Vector2(-1, -1))
			st.add_vertex(Vector3(xbl2, ybl2, 0))
			
			print("running")
	
	st.generate_normals()
	st.generate_tangents()
	# Commit to a mesh.
	var mesh = st.commit()
	$MeshInstance3D.mesh = mesh

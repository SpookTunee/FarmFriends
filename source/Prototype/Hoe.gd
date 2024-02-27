extends Node3D

var tilLand = preload("res://Prototype/Plant_prototype/tilled_land.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	$AnimationPlayer.play("hoe")
	#var npos = Vector2i(0,0)
	#npos.x = abs(int(
		#(global_position.x-50.0)*(64.0/100.0)
	#))
	#npos.y = abs(int(
		#(global_position.z-50.0)*(64.0/100.0)
	#))
	#npos = Vector2i(64,64)-npos
	#var tpos = get_node("/root/World/Terrain").global_position + Vector3(float(npos.x)*(100.0/64.0),float(sin((float(npos.x)*(100.0/64.0))/8)*cos((float(npos.y)*(100.0/64.0))/8)*2), float(npos.y)*(100.0/64.0)) - Vector3(50, 0, 50)
	var Look = get_parent().get_parent().get_child(0)
	if Look.get_collider() && (Look.get_collider().name == "Terrain"):
		var till = tilLand.instantiate()
		get_node("/root/World").add_child(till)
		var tpos = Vector3(int(Look.get_collision_point().x*1000)%int((64.0/100.0)*1000),int(Look.get_collision_point().y*1000)%int((64.0/100.0)*1000),int(Look.get_collision_point().z*1000)%int((64.0/100.0)*1000))/1000
		till.position = tpos#Look.get_collision_point()

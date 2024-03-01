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
	if multiplayer.multiplayer_peer:

		var Look = get_parent().get_parent().get_child(0)
		if Look.get_collider() && (Look.get_collider().name == "Terrain"):
			spawn_hoe.rpc(Look.get_collision_point())
			var till = tilLand.instantiate()
			till.name = "mpSpawned_self_till_"
			get_node("/root/World").add_child(till)
			till.position = (Look.get_collision_point())

@rpc("any_peer","unreliable","call_remote")
func spawn_hoe(pos:Vector3):
	var till = tilLand.instantiate()
	till.name = "mpSpawned_" + str(multiplayer.get_remote_sender_id()) + "_till_"
	get_node("/root/World").add_child(till)
	till.position = pos

extends Node3D

const tilLand = preload("res://Prototype/Plant_prototype/tilled_land.tscn")

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
			get_node("/root/World/").spawn_hoe.rpc(Look.get_collision_point(),get_node("/root/World/").tcount)
			var till = tilLand.instantiate()
			till.name = "mpSpawned_self_till_" + str(get_node("/root/World/").tcount)
			get_node("/root/World").add_child(till)
			till.position = (Look.get_collision_point())
			get_node("/root/World/").tcount += 1

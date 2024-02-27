extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func activate():
	var Look = get_parent().get_parent().get_child(0)
	if Look.get_collider().name == "TilledLand":
		Look.get_collider().grow()

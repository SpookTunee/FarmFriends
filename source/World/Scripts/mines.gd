extends Node


@rpc("call_local")
func minePlace(pos):
	var instance = load("res://Tools/mine.tscn").instantiate()
	get_node("/root/World/Mines").add_child(instance)
	instance.instance(pos)

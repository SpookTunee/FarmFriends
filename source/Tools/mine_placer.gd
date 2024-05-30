extends Node3D

func activate():
	if get_node("../../../MineCooldown").is_stopped():
		if get_node("../../..").item_state["misc"]["mine"]["count"] > 0:
			get_node("/root/World/Mines").minePlace.rpc($Spawner.global_position)
			get_node("../../../MineCooldown").start()
			get_node("../../..").item_state["misc"]["mine"]["count"] -= 1

extends Node3D

func activate():
	if get_node("../../../MineCooldown").is_stopped():
		get_node("/root/World/Mines").minePlace.rpc($Spawner.global_position)
		get_node("../../../MineCooldown").start()

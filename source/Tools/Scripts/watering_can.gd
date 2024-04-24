extends Node3D

var is_active:bool = false
var waitatick:bool = false

func _physics_process(_delta):
	$GPUParticles3D.emitting = is_active
	if waitatick:
		waitatick = false
	else:
		is_active = false
	if is_active:
		var info = {}
		for till in $water_area.get_overlapping_bodies():
			if till.get_parent().water_level < (1.0-0.025):
				till.get_parent().water_level += 0.024
				info[till.get_parent().name] = till.get_parent().water_level
		get_node("/root/World/PlantHandler").drought.rpc(info)

func activate():
	is_active = true
	waitatick = true

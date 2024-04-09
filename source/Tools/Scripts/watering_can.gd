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
		for till in $water_area.get_overlapping_bodies():
			if till.get_parent().water_level < (1.0-0.0125):
				till.get_parent().water_level += 0.010

func activate():
	is_active = true
	waitatick = true

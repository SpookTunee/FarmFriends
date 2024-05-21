extends Node3D

var activated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.is_stopped() and activated:
		activated = false
	if activated:
		#if get_parent().get_child()
		for x in $Area3D.get_overlapping_areas():
			if activated:
				if x.name.substr(0, 3) == "Hit":
					x.get_parent().recieve_damage.rpc_id(x.get_parent().get_multiplayer_authority(),0.667)
					activated = false
			else:
				break
	
func activate():
	if !activated and $Timer.is_stopped():
		$Timer.start()
		activated = true

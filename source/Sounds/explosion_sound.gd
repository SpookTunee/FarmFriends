extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var randomize : float = randf_range(-0.10, 0.50)
	$ExplosionSound.set_pitch_scale(1 + randomize)
	playSound.rpc()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


@rpc("any_peer", "call_local", "unreliable")
func playSound():
	$ExplosionSound.play()


func relocate(pos):
	global_position = pos
	
	

func _on_timer_timeout():
	queue_free()

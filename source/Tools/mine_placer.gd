extends Node3D

var mine = preload("res://Tools/mine.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	$Cd.set_wait_time(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($Cd.time_left)


func activate():
	if $Cd.time_left == 0.0:
		run.rpc()
		$Cd.set_wait_time(30.0)
		$Cd.start()


@rpc("call_local")
func run():
	var instance = mine.instantiate()
	get_parent().get_parent().get_parent().find_child("itemsExtention").add_child(instance)
	instance.instance($Spawner.global_position)

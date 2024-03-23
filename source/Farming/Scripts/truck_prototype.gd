extends Node3D

var check : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = 100000000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.day == 6:
		position.y = 0
		if check:
			$AnimationPlayer.play("TruckEnter")
			check = false
	if Global.day != 6 || Global.day != 0:
		check = true
		position.y = 100000000

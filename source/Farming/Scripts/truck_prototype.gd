extends Node3D

var check : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = 100000000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
	if Global.dayName == "Saturday":
		position.y = 0
		if check:
			$AnimationPlayer.play("TruckEnter")
			check = false
	if Global.dayName != "Saturday" || Global.dayName != "Sunday":
		check = true
		position.y = 100000000

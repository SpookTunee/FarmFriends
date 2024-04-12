extends Node3D

var check : bool = true
@export var active :  bool = false # for testing purposes. final version this will always be true

func _ready():
	if active:
		position.y = 100000000



func _process(delta):
	if active:
		if Global.day == 6:
			position.y = 0
			if check:
				$AnimationPlayer.play("TruckEnter")
				check = false
		if Global.day != 6 || Global.day != 0:
			check = true
			position.y = 100000000

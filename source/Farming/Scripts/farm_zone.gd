extends Area3D

@export var zone_name: String
@export var property_owner: Node3D
@export_enum("None","Plains", "Mountainous", "River", "Forest") var terrain_type : int = 0
@export var farmable: bool = true
@export_flags("yield_boost","farming_speed","grow_speed","move_speed") var effects: int


func parse():
	if effects == 0:
		return []
	elif effects == 1:
		return [1]
	elif effects == 2:
		return [2]
	elif effects == 3:
		return [1,2]
	elif effects == 4:
		return [4]
	elif effects == 5:
		return [1,4]
	elif effects == 6:
		return [2,4]
	elif effects == 7:
		return [1,2,4]
	elif effects == 8:
		return [8]
	elif effects == 9:
		return [1,8]
	elif effects == 10:
		return [2,8]
	elif effects == 12:
		return [4,8]
	elif effects == 11:
		return [1,2,8]
	elif effects == 15:
		return [1,2,4,8]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#he he he ha

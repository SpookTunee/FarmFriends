extends Node3D
var plant = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("e"):
		plant += 1
	if plant > 4:
		plant = 0


func activate():
	var Look = get_parent().get_parent().get_child(0)
	if Look.get_collider() && (Look.get_collider().name == "TilledLand"):
		Look.get_collider().get_parent().grow(plant)

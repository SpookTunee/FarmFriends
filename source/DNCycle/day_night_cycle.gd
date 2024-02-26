extends Node3D

@export var cycle_sec: int = 30
var starting_rotation = -20

# Called when the node enters the scene tree for the first time.
func _ready():
	$DirectionalLight3D.rotation.x = starting_rotation*PI/180


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$DirectionalLight3D.rotation.x += 360*delta/cycle_sec*PI/180
	$DirectionalLight3D.light_energy = 1+(cos($DirectionalLight3D.rotation.x)/2)
	if $DirectionalLight3D.rotation.x >= 2*PI:
		$DirectionalLight3D.rotation.x = 0

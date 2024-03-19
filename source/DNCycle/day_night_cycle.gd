extends Node3D

@export var cycle_sec: int = 30
var starting_rotation = -35
@onready var daycheck : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$DirectionalLight3D.rotation.x = starting_rotation*PI/180
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$DirectionalLight3D.rotation.x += 360*delta/cycle_sec*PI/180
	$DirectionalLight3D2.rotation.x = -$DirectionalLight3D.rotation.x
	$DirectionalLight3D.light_energy = 1+(cos($DirectionalLight3D.rotation.x)/2)
	$DirectionalLight3D2.light_energy = 1+(cos(-($DirectionalLight3D.rotation.x))/2) * 1.5 + 0.5
	if $DirectionalLight3D.rotation.x >= 2*PI:
		$DirectionalLight3D.rotation.x = 0
	if $DirectionalLight3D.rotation_degrees.x > 90 - 5 && $DirectionalLight3D.rotation_degrees.x < 90 + 5 && daycheck:
		daycheck = false
		Global.day += 1
	if $DirectionalLight3D.rotation_degrees.x >= -10 && $DirectionalLight3D.rotation_degrees.x <= 10:
		daycheck = true

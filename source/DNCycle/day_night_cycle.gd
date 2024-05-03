extends Node3D

@export var cycle_sec: int = 30
var starting_rotation = 210
var check : bool = true
var currday : int
signal dayChange
# Called when the node enters the scene tree for the first time.
func _ready():
	currday = floor(Global.dayfloat)
	$DirectionalLight3D.rotation.x = starting_rotation*PI/180
	
func is_day():
	return 200 < $DirectionalLight3D.rotation_degrees.x < 340
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.dayfloat += (delta/cycle_sec)
	Global.day = floor(Global.dayfloat)
	if currday != Global.day:
		dayChange.emit()
		currday = Global.day
	$DirectionalLight3D.rotation.x += deg_to_rad(360.0*(delta/cycle_sec))
	$DirectionalLight3D2.rotation.x = -$DirectionalLight3D.rotation.x +45
	$DirectionalLight3D3.rotation.x = -$DirectionalLight3D.rotation.x -45
	$DirectionalLight3D.light_energy = 1+(cos($DirectionalLight3D.rotation.x)/2)
	$DirectionalLight3D2.light_energy = 1+(cos(-($DirectionalLight3D.rotation.x))/2) * 1.5 + 0.8
	$DirectionalLight3D3.light_energy = 1+(cos(-($DirectionalLight3D.rotation.x))/2) * 1.5 + 0.8
	if $DirectionalLight3D.rotation.x >= 2*PI:
		$DirectionalLight3D.rotation.x = 0
		
	
		
	
	if Global.get_day_name() == "Monday" && check && Global.day > 3:
		check = false
		Global.quotaPrice *= 1.5
		
	if Global.get_day_name() != "Monday":
		check = true

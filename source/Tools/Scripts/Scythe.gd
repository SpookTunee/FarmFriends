extends Node3D

var cutting = false
var cooldown = false

func _ready():
	$scythe/es.timeout.connect(_es_end)
	$scythe/ss.timeout.connect(_ss_end)
	
func _physics_process(_delta):
	if cutting:
		if multiplayer.multiplayer_peer:
			var Look = $scythe/Area3D
			var con
			for i in Look.get_overlapping_areas():
				if i.name == "PlantBox":
					con = i
					$scythe/CutNoise.play()
					break
			if con:
				#if !con.get_parent().get_node("Plant/PlantBody/AnimationPlayer").is_playing():
				con.get_parent().get_parent().harvest_plant(con.get_parent().plant_id)

func init_pos():
	$scythe/AnimationPlayer.play("scythe")
	$scythe/AnimationPlayer.stop()

func activate():
	$scythe/AnimationPlayer.play("scythe")
	if !cooldown:
		$scythe/ss.start()
		cooldown = true
		cutting = true

func _ss_end():
	cutting = false
	$scythe/es.start()
	
func _es_end():
	cooldown = false
